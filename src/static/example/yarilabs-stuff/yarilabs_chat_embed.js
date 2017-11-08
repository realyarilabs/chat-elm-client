(function() {
  function async_load(){
    	var iframe = document.createElement('iframe');
      iframe.id = "yarilabs-iframe";
      iframe.src = "index.html";


      var link = document.createElement( "link" );
      link.href = "iframe.css";
      link.type = "text/css";
      link.rel = "stylesheet";

      document.body.appendChild(iframe);
      document.getElementsByTagName( "head" )[0].appendChild( link );
  }
  if (window.attachEvent)
    window.attachEvent('onload', async_load);
  else
    window.addEventListener('load', async_load, false);
})();
