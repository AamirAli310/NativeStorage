/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package com.scad.roshanApp;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

import android.content.Context;
import android.content.res.AssetManager;
import android.net.Uri;
import org.apache.cordova.*;
import org.apache.cordova.CordovaResourceApi.OpenForReadResult;
import org.json.JSONArray;
import org.json.JSONException;


public class NativeStorage extends CordovaPlugin {


	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
	    super.initialize(cordova, webView);
	    System.out.println("Its calling from Native Storage");
	}
	
	@Override	
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {        
		try {
			if(action.equals("getFileContentRequest")){
				
				getFileContent(args.getString(0), callbackContext);
				
				return true;
				
			} else if(action.equals("setFileContentRequest")){
				
				boolean writeStatus = setFileContent(args);
				
				callbackContext.success(writeStatus?1:0);
				
				return true;
			}			
	    }
	    catch (Exception exp) {
	    	callbackContext.error(0);
	    }
		
	    return false;  // Returning false results in a "MethodNotFound" error.
	}

	public void getFileContent(String filename, CallbackContext callbackContext){
			
		String fileDataStr = null;
	    
	    if (filename != null && filename.length() > 0) {	        

	    	try {
	    		
    			Context context = this.cordova.getActivity().getApplicationContext();
    			filename = filename.replace("js/", "");
    			File f = new File(context.getFilesDir()+"/"+filename);
    			if(f.exists())
    			{
    				InputStream is = new FileInputStream(f);    				    				
    				fileDataStr = getJSONStrFromIS(is);
    				callbackContext.success(fileDataStr);    				
    				
    			}else{
    				callbackContext.error("something went wrong");
    			}    			
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				
				callbackContext.error("something went wrong");
			}	    	
	    }	    
	}
	
	public boolean setFileContent(JSONArray args) throws JSONException{
		
		boolean isFileSaved = false;
		try{
			
			if(args == null || args.length() == 0)
				return isFileSaved;
			
			if(args.length() >= 2 ){
				
				String filename = args.getString(0);
				filename = filename.replace("js/", "");
				String fileDataStr = args.getString(1);
		    
				FileOutputStream outputStream;
	
				Context context = this.cordova.getActivity().getApplicationContext();
				
				outputStream = context.openFileOutput(filename, context.MODE_PRIVATE);
				outputStream.write(fileDataStr.getBytes());
				outputStream.close();
				
				isFileSaved = true;			
			}			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		    	
		}
	    return  isFileSaved;
	}
	
	///UTILITY FUNCTIONS
	static String getJSONStrFromIS(java.io.InputStream is) {
		 String json = null;
	        try {

	            int size = is.available();

	            byte[] buffer = new byte[size];

	            is.read(buffer);

	            is.close();

	            json = new String(buffer, "UTF-8");

	        } catch (IOException ex) {
	            ex.printStackTrace();
	            return null;
	        }
	        return json;
	}

}
