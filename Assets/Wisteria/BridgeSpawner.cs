using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BridgeSpawner : MonoBehaviour {

    public GameObject bridgePart;
    public int bridgeL;
    public GameObject bHolder;
    
    void Awake ()
    {
        GameObject newB = Instantiate(bridgePart);
        newB.transform.parent = bHolder.transform;
        Transform spawn = newB.transform.GetChild(0); 
        for (int i = 0; i < bridgeL; i++)
        {
            newB = Instantiate(bridgePart, spawn);
            spawn = newB.transform.GetChild(0);
            newB.transform.parent = bHolder.transform;
        }
	}
}
