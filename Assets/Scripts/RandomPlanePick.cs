using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomPlanePick : MonoBehaviour
{
    public GameObject[] planes;
    // Start is called before the first frame update
    void Start()
    {
        int start2 = Random.Range(0, planes.Length);
        CamFolow.target = planes[start2].transform;
        System.Collections.Generic.List<GameObject> list = new System.Collections.Generic.List<GameObject>(planes);
        list.Remove(planes[start2]);
        GameObject[] new_planes;
        new_planes = list.ToArray();
        foreach(GameObject item in new_planes)
                {
                    Destroy(item);
                }
    }

    // // Update is called once per frame
    // void Update()
    // {
    //
    // }
}
