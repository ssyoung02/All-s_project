function loadScript(url, callback)
  {
  // Adding the script tag to the head as suggested before
  var head = document.head;
  var script = document.createElement('script');
  script.type = 'text/javascript';
      script.src = url;
  
  // Then bind the event to the callback function.
  // There are several events for cross browser compatibility.
      script.onreadystatechange = callback;
      script.onload = callback;
  
  // Fire the loading
      head.appendChild(script);
  }
// Promise.all (필요에 따라 사용)
Promise.all([
    loadScript('/resources/js/index.js'),
    loadScript('/resources/js/mainComponent.js'),
    loadScript('/resources/js/joinValidChecker.js'),
    loadScript('/resources/js/timer.js')
]).then(() => {
    console.log('All scripts loaded successfully');
}).catch((error) => {
    console.error('Error loading scripts:', error);
});
