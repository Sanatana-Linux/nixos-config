{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.searxng;

  # SearXNG settings.yml. The secret_key is NOT set here — it's provided via the
  # SEARXNG_SECRET env var (see env list below) which the settings system reads
  # via envion_name='SEARXNG_SECRET' in settings_defaults.py.
  # The Nix store path is mounted :ro — read-only is fine since the entrypoint
  # only modifies the file to replace "ultrasecretkey", which we avoid entirely.
  settingsYaml = pkgs.writeText "searxng-settings.yml" ''
    # SearXNG configuration — managed by NixOS
    # See: https://docs.searxng.org/admin/settings/

    use_default_settings: true

    general:
      instance_name: "SearXNG"
      enable_metrics: false
      privacypolicy_url: false
      donation_url: false
      contact_url: false

    ui:
      static_use_hash: true
      # Open search results in new tab
      results_on_new_tab: true

    server:
      # secret_key excluded — set via SEARXNG_SECRET env var below
      image_proxy: true
      method: "GET"
      limiter: false  # private instance — no rate limiting
      public_instance: false

    search:
      safe_search: 0
      autocomplete: "google"
      autocomplete_min: 2
      default_lang: "auto"
      formats:
        - html
        - json

    # ── Engines ──────────────────────────────────────────
    # All engines below enabled with disabled: false (plus inactive: false for
    # engines that default to inactive). Engine names verified against:
    # https://github.com/searxng/searxng/blob/master/searx/settings.yml
    engines:
      # --- Disabled by default ---
      - name: 500px
        disabled: false
      - name: 9gag
        disabled: false
      - name: acfun
        disabled: false
      - name: alpine linux packages
        disabled: false
      - name: annas archive
        disabled: false
      - name: apk mirror
        disabled: false
      - name: anaconda
        disabled: false
      - name: nixos wiki
        disabled: false
      - name: artstation
        disabled: false
      - name: ayo
        disabled: false
      - name: bing
        disabled: false
      - name: bitchute
        disabled: false
      - name: bitbucket
        disabled: false
      - name: bpb
        disabled: false
      - name: btdigg
        disabled: false
      - name: media.ccc.de
        disabled: false
      - name: cachy os packages
        disabled: false
      - name: cara
        disabled: false
      - name: crossref
        disabled: false
      - name: crowdview
        disabled: false
      - name: deezer
        disabled: false
      - name: destatis
        disabled: false
      - name: ddg definitions
        disabled: false
      - name: encyclosearch
        disabled: false
      - name: erowid
        disabled: false
      - name: dogpile
        disabled: false
      - name: dogpile images
        disabled: false
      - name: dogpile videos
        disabled: false
      - name: dogpile news
        disabled: false
      - name: duckduckgo web
        disabled: false
      - name: duckduckgo weather
        disabled: false
      - name: apple maps
        disabled: false
      - name: emojipedia
        disabled: false
      - name: tineye
        disabled: false
      - name: 1x
        disabled: false
      - name: fdroid
        disabled: false
      - name: findfiles
        disabled: false
      - name: findfiles images
        disabled: false
      - name: findfiles videos
        disabled: false
      - name: findfiles music
        disabled: false
      - name: findthatmeme
        disabled: false
      - name: flaticon
        disabled: false
      - name: free software directory
        disabled: false
      - name: frinkiac
        disabled: false
      - name: fynd
        disabled: false
      - name: fyyd
        disabled: false
      - name: gabanza
        disabled: false
      - name: geizhals
        disabled: false
      - name: giphy
        disabled: false
      - name: gitlab
        disabled: false
      - name: codeberg
        disabled: false
      - name: gitea.com
        disabled: false
      - name: gmx
        disabled: false
      - name: goodreads
        disabled: false
      - name: google play apps
        disabled: false
      - name: google play movies
        disabled: false
      - name: material icons
        disabled: false
      - name: habrahabr
        disabled: false
      - name: hackernews
        disabled: false
      - name: hex
        disabled: false
      - name: crates.io
        disabled: false
      - name: il post
        disabled: false
      - name: huggingface
        disabled: false
      - name: huggingface datasets
        disabled: false
      - name: huggingface spaces
        disabled: false
      - name: imdb
        disabled: false
      - name: imgur
        disabled: false
      - name: ina
        disabled: false
      - name: ipernity
        disabled: false
      - name: jisho
        disabled: false
      - name: library genesis
        disabled: false
      - name: library of congress
        disabled: false
      - name: lobste.rs
        disabled: false
      - name: magnific
        disabled: false
      - name: mastodon hashtags
        disabled: false
      - name: metacpan
        disabled: false
      - name: microsoft learn
        disabled: false
      - name: mozhi
        disabled: false
      - name: mwmbl
        disabled: false
      - name: niconico
        disabled: false
      - name: npm
        disabled: false
      - name: nyaa
        disabled: false
      - name: odysee
        disabled: false
      - name: ollama
        disabled: false
      - name: openalex
        disabled: false
      - name: openlibrary
        disabled: false
      - name: openmeteo
        disabled: false
      - name: openrepos
        disabled: false
      - name: packagist
        disabled: false
      - name: picjumbo
        disabled: false
      - name: pixabay images
        disabled: false
      - name: pixabay videos
        disabled: false
      - name: podchaser
        disabled: false
      - name: pub.dev
        disabled: false
      - name: public domain image archive
        disabled: false
      - name: quark
        disabled: false
      - name: quark images
        disabled: false
      - name: reddit
        disabled: false
      - name: searchmysite
        disabled: false
      - name: selfhst icons
        disabled: false
      - name: shopify stock
        disabled: false
      - name: stocksnap
        disabled: false
      - name: discuss.python
        disabled: false
      - name: caddy.community
        disabled: false
      - name: pi-hole.community
        disabled: false
      - name: privacywall
        disabled: false
      - name: privacywall images
        disabled: false
      - name: privacywall videos
        disabled: false
      - name: steam
        disabled: false
      - name: tokyotoshokan
        disabled: false
      - name: tagesschau
        disabled: false
      - name: tmdb
        disabled: false
      - name: yandex
        disabled: false
      - name: yandex images
        disabled: false
      - name: yandex music
        disabled: false
      - name: wikibooks
        disabled: false
      - name: wikiquote
        disabled: false
      - name: wikisource
        disabled: false
      - name: wikispecies
        disabled: false
      - name: wikiversity
        disabled: false
      - name: wikivoyage
        disabled: false
      - name: 1337x
        disabled: false
      - name: duden
        disabled: false
      - name: mojeek
        disabled: false
      - name: mojeek images
        disabled: false
      - name: mojeek news
        disabled: false
      - name: national vulnerability database
        disabled: false
      - name: naver
        disabled: false
      - name: naver images
        disabled: false
      - name: naver news
        disabled: false
      - name: naver videos
        disabled: false
      - name: rubygems
        disabled: false
      - name: peertube
        disabled: false
      - name: mediathekviewweb
        disabled: false
      - name: rumble
        disabled: false
      - name: reloado
        disabled: false
      - name: resulthunter
        disabled: false
      - name: resulthunter images
        disabled: false
      - name: uxwing
        disabled: false
      - name: voidlinux
        disabled: false
      - name: zapmeta
        disabled: false
      - name: lib.rs
        disabled: false
      - name: sourcehut
        disabled: false
      - name: pkg.go.dev
        disabled: false
      - name: senscritique
        disabled: false
      - name: infospace
        disabled: false

      # --- Inactive by default (needs API keys / extra config) ---
      - name: astrophysics data system
        disabled: false
        inactive: false
      - name: avalw
        disabled: false
        inactive: false
      - name: azure
        disabled: false
        inactive: false
      - name: cl0q
        disabled: false
        inactive: false
      - name: core.ac.uk
        disabled: false
        inactive: false
      - name: elasticsearch
        disabled: false
        inactive: false
      - name: ebay
        disabled: false
        inactive: false
      - name: github code
        disabled: false
        inactive: false
      - name: google
        disabled: false
        inactive: false
      - name: google images
        disabled: false
        inactive: false
      - name: google videos
        disabled: false
        inactive: false
      - name: z-library
        disabled: false
        inactive: false
      - name: libretranslate
        disabled: false
        inactive: false
      - name: luxxle
        disabled: false
        inactive: false
      - name: luxxle images
        disabled: false
        inactive: false
      - name: luxxle videos
        disabled: false
        inactive: false
      - name: luxxle news
        disabled: false
        inactive: false
      - name: marginalia
        disabled: false
        inactive: false
      - name: neocities
        disabled: false
        inactive: false
      - name: openclipart
        disabled: false
        inactive: false
      - name: piped
        disabled: false
        inactive: false
      - name: piped.music
        disabled: false
        inactive: false
      - name: pixiv
        disabled: false
        inactive: false
      - name: rawweb
        disabled: false
        inactive: false
      - name: springer nature
        disabled: false
        inactive: false
      - name: tonline
        disabled: false
        inactive: false
      - name: tonline images
        disabled: false
        inactive: false
      - name: tonline videos
        disabled: false
        inactive: false
      - name: tonline news
        disabled: false
        inactive: false
      - name: unobtanium
        disabled: false
        inactive: false
      - name: youtube_api
        disabled: false
        inactive: false
      - name: deepl
        disabled: false
        inactive: false
      - name: repology
        disabled: false
        inactive: false
      - name: wallhaven
        disabled: false
        inactive: false
  '';
in {
  options.modules.system.apps.searxng = {
    enable = mkEnableOption "SearXNG self-hosted search engine (Docker container)";

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Host port to map SearXNG's internal port 8080 to";
    };

    image = mkOption {
      type = types.str;
      default = "searxng/searxng:latest";
      description = "SearXNG Docker image tag to use";
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra options to pass to the OCI container";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.system.virtualization.docker.enable;
        message = "SearXNG requires Docker (modules.system.virtualization.docker.enable = true)";
      }
    ];

    # Declare the SearXNG secret in sops-nix. The encrypted value must be added
    # to external/secrets/secrets.yaml with key name "searxng_secret" and the
    # value in key=value format: SEARXNG_SECRET=<secret>
    sops.secrets.searxng_secret = {};

    # OCI container for SearXNG — starts at boot via Docker
    virtualisation.oci-containers.containers."searxng" = {
      image = cfg.image;
      ports = ["${toString cfg.port}:8080"];
      autoStart = true;
      # Mount generated config; container's entrypoint merges with defaults
      volumes = [
        "${settingsYaml}:/etc/searxng/settings.yml:ro"
      ];
      # secret_key is provided via env var from sops-nix managed file
      # (settings_defaults.py reads environ_name='SEARXNG_SECRET'), not from
      # settings.yml. This avoids the entrypoint needing write access to the
      # read-only Nix store mount.
      environmentFiles = [
        config.sops.secrets.searxng_secret.path
      ];
      extraOptions = cfg.extraOptions;
    };
  };
}
