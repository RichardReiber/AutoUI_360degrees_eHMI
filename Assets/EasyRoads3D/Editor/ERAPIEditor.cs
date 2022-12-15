using UnityEngine;
using UnityEditor;
using System.Collections;
using EasyRoads3Dv3;
using EasyRoads3Dv3Editor;


public class ERAPIEditor : Editor {

	[InitializeOnLoadMethod]
	static void OnLoad()
	{
		#if UNITY_2021_2
		if (EditorPrefs.GetString("ERVersion") != "UNITY_2021_2")
		{
			string path = "Assets/EasyRoads3D/Unity_2021_2.unitypackage";
			if (System.IO.File.Exists(Application.dataPath.Replace("Assets", "") + path))
			{
				AssetDatabase.ImportPackage(path, false);
			}
			EditorPrefs.SetString("ERVersion", "UNITY_2021_2");
		}
		#endif
	}
}
