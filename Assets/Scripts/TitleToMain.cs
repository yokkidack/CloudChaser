
using UnityEngine;
using UnityEngine.SceneManagement;

public class TitleToMain : MonoBehaviour
{
    [SerializeField]
        private
        string WhatSceneToLoad;

        public void LoadDefinedScene()
        {
            SceneManager.LoadScene(WhatSceneToLoad);
        }
}
