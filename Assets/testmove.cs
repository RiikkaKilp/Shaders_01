using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class testmove : MonoBehaviour {

    Rigidbody rb;

    void Start () {
        rb = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        float hor = Input.GetAxis("Horizontal");
        float speed = 10f;
        rb.velocity = new Vector3(hor * speed * Time.deltaTime, 0, 0) * speed;
	}
}
