{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.nur.hmModules.nur
    inputs.self.homeManagerModules.general
    inputs.self.homeManagerModules.templates
  ];


  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles = {
        default = {
          id = 0;
          settings = {
          "app.shield.optoutstudies.enabled" = false;
            "browser.contentblocking.category" = "custom";
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.formfill.enable" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.enabled" = true;
            "browser.ping-centre.telemetry" = false;
            "browser.search.defaultenginename" = "DuckDuckG";
            "browser.search.openintab" = true;
            "browser.search.selectedEngine" = "DuckDuckG";
            "browser.startup.homepage" = "about:home";
            "browser.startup.page" = 1;
            "browser.theme.content-theme" = 0;
            "browser.theme.toolbar-theme" = 0;
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.uidensity" = 1;
            "browser.urlbar.placeholderName" = "DuckDuckG";
            "browser.urlbar.suggest.bookmark" = false;
            "browser.urlbar.suggest.history" = false;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.topsites" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.supported" = false;
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "extensions.autoDisableScopes" = 0;
            "extensions.pocket.enabled" = false;
            "identity.fxaccounts.enabled" = false;
            "keyword.enabled" = true;
            "mousewheel.with_alt.action" = 1;
            "network.allow-experiments" = false;
            "network.cookie.lifetimePolicy" = 2;
            "places.history.enabled" = false;
            "privacy.donottrackheader.enable" = true;
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "signon.rememberSignons" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "network.proxy.type" = 1;
            "network.proxy.socks" = "127.0.0.1";
            "network.proxy.socks_port" = 4447;
            "network.proxy.http" = "127.0.0.1";
            "network.proxy.http_port" = 4444;
          };
        };
      };
    };
  };
}
