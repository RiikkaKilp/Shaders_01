using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileMovement : MonoBehaviour {

    public Timer timer;

    public GameObject projectile;

    public GameObject[] detector;
    GameObject note;

    List<GameObject> allNotes = new List<GameObject>();

    int projectileAmount = 10;
    float speed = 1f;

	void Start ()
    {
		for (int i = 0; projectileAmount > i; i++)
        {
            // Something's fucky
            note = Instantiate(projectile, transform.position, transform.rotation);
            allNotes.Add(note);
            //Debug.Log(allNotes[i].name);
        }
	}

    void Update()
    {
        if (timer.timer > 0 && timer.timerStarted == true)
        {
            allNotes[0].SetActive(true);
            float step = speed * Time.deltaTime;
            allNotes[0].transform.position = Vector3.MoveTowards(transform.position, detector[0].transform.position, speed);

        }
    }
}
