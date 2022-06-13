using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Movement : MonoBehaviour {

	public Vector3 velocity;

	private void Update()
    {
        transform.position += velocity * Time.deltaTime;
    }
}
