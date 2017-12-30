using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingPlatform1 : MonoBehaviour {


    Vector3 startPos;

	void Start ()
    {
        startPos = transform.position;
	}
	
	void FixedUpdate ()
    {
        transform.position = startPos + new Vector3(0, Mathf.Sin(Time.time) * -1, 0);
	}
}
