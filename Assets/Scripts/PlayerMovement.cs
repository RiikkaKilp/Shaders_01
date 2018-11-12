using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour {

    public int speed;
	
	// Update is called once per frame
	void Update ()
    {
        var x = Input.GetAxis("Horizontal") * Time.deltaTime *speed;
        var z = Input.GetAxis("Vertical") * Time.deltaTime * speed;

        //transform.Rotate(0, 0, 0);
        transform.Translate(x, 0, z);
    }
}
