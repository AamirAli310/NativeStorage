/**
 * @author Aamir Ali | aadin@scad.ae
 * @desc CPI APP
 * @created on 07/MAY/2016
 */

var nativeStorage = angular.module('nativeStorageModule', [])

    .factory('NativeStorage', function ($http, $q, $rootScope) {

        var self = this;

        self.isNetConnectionAvailable = function(){
            return navigator.onLine;
        };

        self.loadData = function (filename, successFn, errorFn) { //filename with full file path
            /*
            progressIndicator.show();


            if (!self.isNetConnectionAvailable) {

                self.getFileData(filename, successFn, errorFn);

            } else {

                //self.getFileData(filename, successFn, errorFn); //This line will fire from saveDataInFile fun
                //$http.get('https://demo2315600.mockable.io/getIndicatorData')
                //    .success(function (data) {
                //
                //        self.saveDataInFile(filename, data);
                //
                //        console.log("JSON Data: " + JSON.stringify(data));
                //
                //        ///return successFn(data);
                //    })
                //    .error(function (errorData) {
                //
                //        $rootScope.app.log(errorData);
                //    });

                $http.post('https://apps.scad.ae/webapi/SCADWebAPI.asmx/RequestRashanData',
                    {
                        "DataRequest": {
                            "MethodName": "GetRashanData",
                            Arguments: {
                                "_Version": $rootScope.app.version.get()
                            }
                        }
                    })
                    .then(function successCallback(resp) {
                        console.log('Success');

                        if(resp.data.d.Data != null){

                            self.saveDataInFile(filename, resp.data.d.Data, function(){
                                    //FILE SAVED IN FILE SUCCESSFULLY
                                    if(angular.isDefined(successFn))
                                        return successFn(resp);
                                },
                                function(){

                                    //AA: LET THE RESPONSE HANDLE BY APP
                                    if(angular.isDefined(successFn))
                                        return successFn(resp);

                                    //GOT ERROR WHILE SAVING FILE
                                    //if(angular.isDefined(errorFn))
                                    //    return errorFn("file not save");
                                });
                        }else{
                            //FILE SAVED IN FILE SUCCESSFULLY
                            if(angular.isDefined(successFn))
                                return successFn(resp);
                        }
                    }, function errorCallback(response) {
                        if(angular.isDefined(errorFn))
                            return errorFn(response);
                    });
            }
            */
        };
        self.getFileData  = function(filename, successFn, errorFn){

            var isIOS = ionic.Platform.isIOS();
            var isAndroid = ionic.Platform.isAndroid();

            try{

                if(angular.isDefined(cordova) && (isIOS || isAndroid)) {

                    document.addEventListener('deviceready',function(){
                        console.log('Device ready fired');

                        cordova.exec(
                            function successCallback(data) { // Register the callback handler

                                //console.log('Got File data' + data);
                                //window.alert("File data is: "+ data);

                                if(angular.isDefined(successFn) && data != null){
                                    return successFn(JSON.parse(data));
                                } else{
                                    return successFn(null);
                                }
                            },
                            function failureCallback(err) { // Register the failureCallback to deal with failure case
                                console.log('Error : '+err);

                                //return errorFn("File not found");
                                if(angular.isDefined(errorFn))
                                    return errorFn("Something went wrong!");

                            },
                            'NativeStorage',//Plugin-Name
                            'getFileContentRequest',//Plugin Method to be called, Either 'getFileContentRequest' OR 'setFileContentRequest'
                            [filename] // An array containing one String, In setFileContentRequest case pass content as 2nd param.
                        );
                    }, false);

                }else{
                    return $http.get(filename).then(successFn,errorFn);
                }
            }
            catch(err) {
                console.log("Cordova undefined");
                if(angular.isDefined(errorFn))
                    return  errorFn("Something went wrong!");
            }

        };

        self.saveDataInFile = function(filename, data , successFn, errorFn){

            var isIOS = ionic.Platform.isIOS();
            var isAndroid = ionic.Platform.isAndroid();

            try {
                if(angular.isDefined(cordova) && (isIOS || isAndroid)) {

                    document.addEventListener('deviceready',function(){

                        console.log('Device ready fired');

                        cordova.exec(
                            function successCallback(data) { // Register the callback handler

                                console.log('File data saved:' + data);
                                if(angular.isDefined(successFn))
                                    return successFn(true);
                            },

                            function failureCallback(err) { // Register the failureCallback to deal with failure case

                                console.log('Error : ' + err);
                                if(angular.isDefined(errorFn))
                                    return errorFn("Something went wrong!");
                            },
                            'NativeStorage',//Plugin-Name
                            'setFileContentRequest',//Plugin Method to be called, Either 'getFileContentRequest' OR 'setFileContentRequest'
                            [filename, JSON.stringify(data)] // An array containing one String
                        );
                    },false);
                }
            }
            catch(err) {
                console.log("Cordova undefined");

                if(angular.isDefined(errorFn))
                    return errorFn("Something went wrong!");
            }
        };

        return {
            getLatestData: self.loadData, //AA: It will request to server if app is online
            getData: self.getFileData,
            setData: self.saveDataInFile
        };
    });