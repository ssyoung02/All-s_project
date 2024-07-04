function loadScript(url) {
    return new Promise((resolve, reject) => {
        if (document.querySelector(`script[src="${url}"]`)) {
            console.log(`Script ${url} is already loaded.`);
            resolve();
            return;
        }

        const script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = url;
        script.onload = () => {
            console.log(`Script ${url} loaded successfully.`);
            resolve();
        };
        script.onerror = () => {
            console.error(`Error loading script ${url}`);
            reject();
        };
        document.head.appendChild(script);
    });
}

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

