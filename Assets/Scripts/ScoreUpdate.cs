using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class ScoreUpdate : MonoBehaviour
{

    public Text Score;
    public static int ScoreCount = 0;

    // Start is called before the first frame update
    void Start()
    {
        Score = GameObject.FindGameObjectWithTag("Score").GetComponent<Text>();
        Score.text = gameObject.GetComponent<Text>().text;
    }

    // Update is called once per frame
    void Update()
    {
        Score.text = "Score : " + ScoreCount.ToString() + "";
    }
}
