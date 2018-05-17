using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileMovement : MonoBehaviour {

    public GameObject projectile;
    GameObject[] detector;
    int projectileAmount = 10;

	void Start ()
    {
		for (int i = 0; projectileAmount > i; i++)
        {
            // Something's fucky
            // detector[i] = Instantiate(projectile, transform.position, transform.rotation);
        }
	}
}
