using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Timer : MonoBehaviour {

    public float timer = 0;
    public bool timerStarted = false;

    public void Update()
    {
        if (timerStarted)
        {
            timer += Time.deltaTime;
        }


        if (timer > 5 && timer < 5.1)
        {
            Debug.Log("The time says 5! Not five o' clock, just five.");
        }
    }

    public float GetTime()
    {
        return timer;
    }

    public void StartTimer()
    {
        timerStarted = true;
    }

    public void StopTimer()
    {
        timerStarted = false;
    }
}
