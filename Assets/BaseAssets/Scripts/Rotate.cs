using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour {

	private void Update () {
		transform.Rotate(new Vector3(0, 45 * Time.deltaTime, 0));
	}
}
