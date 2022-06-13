using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraClouds : MonoBehaviour
{

    public Shader CloudsShader;
    public float MinHeight = 0.0f;
    public float MaxHeight = 5.0f;
    public float FadeDist = 2.0f;
    public float Scale = 5.0f;
    public float Steps = 50.0f;
    public Texture ValueNoiseTexture;
    public Transform SunTransform;

    private Camera _camera;
    public Camera Camera
    {
        get
        {
            if (_camera == null)
                _camera = GetComponent<Camera>();
            return _camera;
        }
    }

    private Material _material = null;
    public Material Material
    {
        get
        {
            if (_material == null && CloudsShader != null)
            {
                _material = new Material(CloudsShader);
            }
            else if (_material != null && CloudsShader == null)
            {
                DestroyImmediate(_material);
            }
            else if (_material != null && CloudsShader != null && CloudsShader != _material.shader)
            {
                DestroyImmediate(_material);
                _material = new Material(CloudsShader);
            }
            return _material;
        }
    }

    private void Start()
    {
        if (_material != null)
        {
            DestroyImmediate(_material);
        }

    }
    private Matrix4x4 GetFrustumCorners()
    {
        Matrix4x4 frustumCorners = Matrix4x4.identity;
        Vector3[] fCorners = new Vector3[4];

        Camera.CalculateFrustumCorners(new Rect(0, 0, 1, 1), Camera.farClipPlane, Camera.MonoOrStereoscopicEye.Mono, fCorners);

        frustumCorners.SetRow(0, Vector3.Scale(fCorners[1], new Vector3(1, 1, -1)));
        frustumCorners.SetRow(1, Vector3.Scale(fCorners[2], new Vector3(1, 1, -1)));
        frustumCorners.SetRow(2, Vector3.Scale(fCorners[3], new Vector3(1, 1, -1)));
        frustumCorners.SetRow(3, Vector3.Scale(fCorners[0], new Vector3(1, 1, -1)));

        return frustumCorners;
    }

    [ImageEffectOpaque]
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (Material == null || ValueNoiseTexture == null)
        {
            Graphics.Blit(source, destination);
            return;
        }

        Material.SetTexture("_ValueNoise", ValueNoiseTexture);
        if (SunTransform != null)
        {
            Material.SetVector("_SunDir", SunTransform.forward);
        }
        else
        {
            Material.SetVector("_SunDir", Vector3.up);
        }
        Material.SetFloat("_MinHeight", MinHeight);
        Material.SetFloat("_MaxHeight", MaxHeight);
        Material.SetFloat("_FadeDist", FadeDist);
        Material.SetFloat("_Scale", Scale);
        Material.SetFloat("_Steps", Steps);


        Material.SetMatrix("_FrustumCornersWS", GetFrustumCorners());
        Material.SetMatrix("_CameraInvViewMatrix", Camera.cameraToWorldMatrix);
        Material.SetVector("_CameraPosWS", Camera.transform.position);

        CustomGraphicsBlit(source, destination, Material, 0);

    }

    private static void CustomGraphicsBlit(RenderTexture source, RenderTexture dest, Material fxMaterial, int passNr)
    {
        RenderTexture.active = dest;

        fxMaterial.SetTexture("_MainTex", source);

        GL.PushMatrix();
        GL.LoadOrtho();

        fxMaterial.SetPass(passNr);

        GL.Begin(GL.QUADS);

        GL.MultiTexCoord2(0, 0.0f, 0.0f);
        GL.Vertex3(0.0f, 0.0f, 3.0f); // BL

        GL.MultiTexCoord2(0, 1.0f, 0.0f);
        GL.Vertex3(1.0f, 0.0f, 2.0f); // BR

        GL.MultiTexCoord2(0, 1.0f, 1.0f);
        GL.Vertex3(1.0f, 1.0f, 1.0f); // TR

        GL.MultiTexCoord2(0, 0.0f, 1.0f);
        GL.Vertex3(0.0f, 1.0f, 0.0f); // TL

        GL.End();
        GL.PopMatrix();
    }

    protected virtual void OnDisable()
    {
        if (_material != null)
        {
            DestroyImmediate(_material);
        }
    }
}
