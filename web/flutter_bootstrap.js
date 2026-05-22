{{flutter_js}}
{{flutter_build_config}}

const loadingEl = document.getElementById('loading');

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function (engineInitializer) {
    try {
      const appRunner = await engineInitializer.initializeEngine();
      if (loadingEl) {
        loadingEl.style.display = 'none';
      }
      await appRunner.runApp();
    } catch (error) {
      console.error('Error initializing Flutter:', error);
      if (loadingEl) {
        loadingEl.innerHTML =
          'Error loading app. Please check console for details.';
      }
    }
  },
});
