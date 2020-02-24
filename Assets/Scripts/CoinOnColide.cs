using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CoinOnColide : MonoBehaviour
{
    public GameObject coin;
    public GameObject coin2;

    //public int numObjects = 10;

    void OnTriggerEnter (Collider other)
    {
        ScoreUpdate.ScoreCount+=1;
        int count = Random.Range(1, 3);
        for (int i = 0; i < count; i++){
            spawn();
        }
        Destroy(coin);
    }

    void spawn(){
        Vector3 screenPosition = Camera.main.ScreenToWorldPoint(new Vector3(Random.Range(0,Screen.width), Random.Range(0,Screen.height), Camera.main.farClipPlane/2.5f));
        screenPosition.y = Mathf.Min(100f+ Random.Range(-10f, 10f), Mathf.Max(-30f + Random.Range(-10f, 30f), screenPosition.y));
        Instantiate(coin2,screenPosition,Quaternion.identity);
    }

    // Vector3 RandomCircle ( Vector3 center ,   float radius  ){
    //      float ang = Random.value * 360;
    //      Vector3 pos;
    //      pos.x = center.x + radius * Mathf.Sin(ang * Mathf.Deg2Rad);
    //      pos.y = center.y + radius * Mathf.Cos(ang * Mathf.Deg2Rad);
    //      pos.z = center.z;
    //      return pos;
    //  }
}
