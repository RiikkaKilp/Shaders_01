using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingPlatform : MonoBehaviour {


    Vector3 startPos;

    [Range(2.0f, -2.0f)]
    public float timingOffset = 1;

    public float y_Movement;

	void Start ()
    {
        startPos = transform.position;
	}
	
	void FixedUpdate ()
    {
        transform.position = startPos + new Vector3(0, Mathf.Sin(Time.time) * y_Movement * timingOffset, 0);
	}
}
