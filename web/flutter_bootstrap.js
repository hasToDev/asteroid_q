 {{flutter_js}}
 {{flutter_build_config}}

 var loading = document.querySelector('#loading');
 var loadingText = document.querySelector('#loading-text');

 _flutter.loader.load({
   serviceWorkerSettings: {
     serviceWorkerVersion: {{flutter_service_worker_version}},
   },
   onEntrypointLoaded: async function(engineInitializer) {
     // initializing engine
     const appRunner = await engineInitializer.initializeEngine();

     // running app
     await appRunner.runApp();

     // remove loading indicator
     window.setTimeout(function () {
       loading.remove();
       loadingText.remove();
       document.body.style.background = "transparent";
     }, 200);
   }
 });