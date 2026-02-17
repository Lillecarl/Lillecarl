---
title: "CV"
type: cv
---

<style>
  /* Your CV styles here - this won't affect the rest of the site */
  .cv {
    /* Override site max-width for CV if desired */
    /* max-width: 800px; */
  }

  .cv-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 1rem;
  }

  .cv-header-info {
    flex: 1;
  }

  .cv-photo {
    width: 150px;
    height: 150px;
    border-radius: 4px;
  }

  .no-margin-bottom {
    margin-bottom: 0;
  }

  .no-margin-top {
    margin-top: 0;
  }

  /* Inline tag list */
  .tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.25rem 0.5rem;
    padding: 0;
    margin: 0.5rem 0;
    list-style: none;
  }

  .tags li {
    margin: 0;
  }

  .tags li:not(:last-child)::after {
    content: " •";
    color: var(--muted, #666);
  }

  .tags li strong {
    font-weight: bold;
  }

  .nobreak-page {
    display: block;
    break-inside: avoid-page;
  }

  /* Spoiler/details styling */
  details {
    margin: 0.5rem 0;
    padding: 0.5rem;
    background: var(--code-bg);
    border-radius: 4px;
    border-left: 3px solid var(--link);
  }

  details summary {
    cursor: pointer;
    font-weight: 500;
    color: var(--link);
  }

  details summary:hover {
    text-decoration: underline;
  }

  details[open] summary {
    margin-bottom: 0.5rem;
  }

  details ul,
  details ol {
    margin: 0.5rem 0;
    padding-left: 1.5rem;
  }

  details p {
    margin: 0.5rem 0;
  }

  details p:first-of-type {
    margin-top: 0;
  }
</style>

<div class="cv-header">
  <div class="cv-header-info">
    <h1>Carl Andersson</h1>
    <p>
      <a href="/contact">contact</a><br>
      <a href="https://github.com/lillecarl">github/lillecarl</a><br>
      <a href="https://www.linkedin.com/in/carlops/">linkedin/carlops</a>
    </p>
  </div>
  <img src="/cv-photo.png" alt="Carl Andersson" class="cv-photo">
</div>

<h2>SUMMARY</h2>
<p>
  DevOps/Site Reliability engineer with 10+ years of experience across infrastructure, networking, and platform
  engineering. I prefer declarative configuration, battle-tested software, and solving problems properly rather than
  quickly. Strong background in network architecture, Kubernetes, and Nix-based infrastructure. I've worked across the
  stack from physical datacenters to cloud platforms, and I build tools when existing ones don't fit.
</p>

<h2>COMPETENCIES</h2>
<ul class="tags">
  <li><strong>Kubernetes</strong> & friends</li>
  <li>Python</li>
  <li>BGP</li>
  <li><strong>Nix/NixOS</strong></li>
  <li>Prometheus</li>
  <li>GitHub Actions</li>
  <li>VXLAN/EVPN</li>
  <li><strong>Terraform</strong></li>
  <li>Docker</li>
  <li>Cilium</li>
  <li>PostgreSQL</li>
  <li>FRR</li>
  <li><strong>Linux</strong></li>
  <li>AWS</li>
  <li>GitLab</li>
  <li>Cumulus Linux (3.x)</li>
  <li>MikroTik</li>
  <li>Grafana</li>
  <li>ClusterAPI</li>
  <li>PowerShell</li>
  <li>C#</li>
  <li>IPv6</li>
  <li>VMware</li>
  <li>QEMU/libvirt</li>
</ul>
<h2>EXPERIENCE</h2>

<div class="nobreak-page">
  <h3 class="no-margin-bottom">Evolvit - Infrastructure Consultant</h3>
  <p class="no-margin-top"><small>Aug 2025 - Present (on hold)</small></p>
  <ul class="tags">
    <li>ClusterAPI</li>
    <li><strong>Kubernetes</strong></li>
    <li><strong>NixOS</strong></li>
    <li>Keycloak</li>
    <li>VMware</li>
  </ul>
  <p>
    Building a production Kubernetes environment on VMware for Evolvit. Full platform including ClusterAPI-managed
    control plane, Cilium networking, OIDC authentication and all bells & whistles. Training staff on Kubernetes, Nix,
    and Linux administration. Project on hold due to client capacity constraints.
  </p>
</div>

<div class="nobreak-page">
  <h3 class="no-margin-bottom">Helicon - Infrastructure Consultant</h3>
  <p class=no-margin-top><small>Sep 2023 - Feb 2025</small></p>

  <h4 class="no-margin-bottom">Stockholm Exergi</h4>
  <ul class="tags">
    <li>AWS</li>
    <li><strong>Terraform</strong></li>
    <li><s>Nomad</s></li>
    <li><s>Consul</s></li>
    <li><s>Vault</s></li>
    <li><strong>Linux</strong></li>
    <li>Python</li>
    <li>Nix</li>
  </ul>
  <p>
    Managed HashiCorp-based infrastructure in AWS. Led Terraform refactoring to
    improve state management and infrastructure reliability. Recommended Kubernetes
    migration path which client later adopted. Developer tooling delivered with
    Nix
  </p>

  <h4>Kraftringen</h4>
  <ul class="tags">
    <li><strong>Kubernetes</strong></li>
    <li>AKS</li>
    <li>CloudnativePG</li>
    <li>Grafana</li>
    <li>Prometheus</li>
    <li>Keycloak</li>
    <li>GitLab</li>
  </ul>
  <p>
    Maintained production AKS cluster with full observability stack. Built
    extensive CNPG monitoring for TimescaleDB workloads in Grafana. Managed
    Kustomize-based deployments and version upgrades.
  </p>
</div>

<div class="nobreak-page">
  <h3 class="no-margin-bottom">Viaplay - Site Reliability Engineer</h3>
  <p class="no-margin-top"><small>Sep 2022 - Aug 2023</small></p>
  <ul class="tags">
    <li><s>OpenStack</s></li>
    <li>AWS</li>
    <li><strong>Terraform</strong></li>
    <li><s>SaltStack</s></li>
    <li><s>Ansible</s></li>
    <li><s>Splunk</s></li>
    <li>Python</li>
    <li><strong>Linux</strong></li>
    <li><s>MAAS</s></li>
    <li>AS202093</li>
    <li>MikroTik</li>
    <li>Cumulus Linux</li>
    <li><s>Palo Alto</s></li>
  </ul>
  <p>
    SRE in the Media Asset Management division managing hybrid cloud
    infrastructure. Responsible for 10+ PB storage infrastructure, transcoding
    compute clusters, and on-premise networking. Architected AWS-to-on-premise
    connectivity for MAM workload distribution. Part of team managing the physical
    infrastructure layer underlying Kubernetes clusters.
  </p>
</div>

<div class="nobreak-page">
  <h3 class="no-margin-bottom">SDNit - Infrastructure Consultant</h3>
  <p class="no-margin-top"><small>Nov 2021 - Sep 2022</small></p>
  <ul class="tags">
    <li><strong>Kubernetes</strong></li>
    <li>AWS</li>
    <li>EKS</li>
    <li><strong>Terraform</strong></li>
    <li><s>RKE2</s></li>
    <li><s>Splunk</s></li>
    <li>GitLab</li>
    <li>Python</li>
    <li><strong>Linux</strong></li>
    <li>Keycloak</li>
    <li>AWS RDS</li>
    <li><s>MongoDB Atlas</s></li>
  </ul>
  <p>
    Consulting for Viaplay. Initiated and deployed Kubernetes for Media Asset
    Management. Managed both on-premise RKE2 and EKS clusters with supporting
    services including Keycloak and observability tooling.
  </p>
  <div class="print-hide">
    <details>
      <summary><strong>Key achievements:</strong></summary>
      <h4>Kubernetes deployment</h4>
      <p>
        Deployed Kubernetes on-premise using RKE2 on Ubuntu with Ansible to consolidate with previously deployed AWS
        infrastructure. Kubernetes replaced a custom SaltStack based "scheduler" that installed systemd units.
        Collaborated with application developers enabling them to write control-plane software (Use Kubernetes jobs to
        run
        heavy processing jobs)
      </p>
      See more at <a href="https://www.sdnit.se/kundcase-viaplay">SDNits website</a>
    </details>
  </div>
</div>

<div class="nobreak-page">
  <h3 class="no-margin-bottom">Dialect - Infrastructure Engineer / SRE</h3>
  <p class="no-margin-top"><small>Mar 2019 - Nov 2021</small></p>
  <ul class="tags">
    <li>AS205834</li>
    <li><strong>Cumulus Linux</strong></li>
    <li>Cisco</li>
    <li>FortiNet</li>
    <li><strong>VMware</strong></li>
    <li>Hyper-V</li>
    <li>Veeam</li>
    <li>Cohesity</li>
    <li><strong>MikroTik</strong></li>
    <li>PowerShell</li>
    <li>Zabbix</li>
    <li>PagerDuty</li>
  </ul>
  <p>
    Technical responsibility for a 6-rack datacenter, reporting directly to CTO for
    infrastructure decisions and purchases. Managed 400-500 VMs. (Including MikroTik
    Cloud Hosted Router instances for customer network isolation)
  </p>
  <div class="print-hide">
    <details>
      <summary><strong>Key achievements:</strong></summary>
      <ul>
        <li><strong>VMware deployment:</strong> Deployed vSphere + vCloud + NSX-T + vSAN stack to replace a unreliable
          Hyper-V
          S2D cluster. Customers got self-service via vCloud portal</li>
        <li><strong>Datacenter consolidation:</strong> Migrated Dialect conglomerate hosting from InterXion to Skövde
          datacenter. Live-migrated VMs over stretched L2, then physically relocated and remounted servers to reuse
          hardware
        </li>
        <li><strong>Network modernisation:</strong> Continued L2 removal for remaining edge cases, deployed EVPN on
          Cumulus
          Linux (Mellanox + Broadcom hardware) for appropriate L2 stretching, initiated IPv6 rollout</li>
        <li><strong>Backup infrastructure:</strong> Deployed Cohesity for VMware and legacy Hyper-V workloads</li>
      </ul>
    </details>
  </div>
</div>

<div class="nobreak-page">
  <h3 class="no-margin-bottom">IT Support & Sysadmin</h3>
  <p class="no-margin-top"><small>2014 - 2019</small></p>
  <div class="print-hide">
    <p>
      IT support and Windows Server administration serving 50+ SME customers (5-50 users each). Built high-quality
      support
      function from scratch together with one colleague, as of 2025 the support team is 15+. Specialized in MikroTik
      networking including site-to-datacenter tunnel infrastructure. PowerShell automation for cross-customer
      environment
      provisioning. This role established the networking foundation that led to my later datacenter and infrastructure
      work.
    </p>
    <details>
      <summary><strong>Key achievements:</strong></summary>
      <ul>
        <li><strong>Network architecture redesign:</strong> Eliminated chronic STP looping issues by migrating customer
          connectivity from L2 tunneling to L3 routing, requiring subnet migrations across the customer base</li>
        <li><strong>O365 crisis response:</strong> When parent company went bankrupt, wrote PowerShell + Puppeteer
          automation
          to create admin users and accept new CSP partnerships across 1000+ Microsoft 365 tenants</li>
        <li><strong>Internal tooling:</strong> Built PBX queue monitoring with notifications, custom TeamViewer
          auto-registration installer (before native support existed), HTTP API for physical phone PBX group
          login/logout
        </li>
        <li>MikroTik and networking instructor for all Dialect branch offices</li>
      </ul>
    </details>
  </div>
</div>

<h2>PROJECTS</h2>

<div class="nobreak-page">
  <h3><a href="https://github.com/lillecarl/nix-csi">nix-csi</a></h3>
  <div class="print-hide">
    <p>
      Kubernetes CSI driver that mounts the Nix store into pods, enabling container image replacement with Nix packages.
      Uses hardlink views with shared inodes for memory-efficient page cache sharing across pods. Works on managed
      Kubernetes without node modifications.
    </p>
    <details>
      <summary>Technical details</summary>
      <p><strong>Problem:</strong> Container images have inefficient layer sharing, fragile build caching, and no
        intrinsic SBOM. Nix solves these at the package level but needed Kubernetes integration.</p>
      <p><strong>How it works:</strong></p>
      <ol>
        <li>DaemonSet deployment—no node modifications required. Works on managed clusters (EKS, GKE, AKS).</li>
        <li>Creates a node-local Nix store at <code>/var/lib/nix-csi</code>.</li>
        <li>For each CSI volume, creates a hardlink view of requested store paths.</li>
        <li>Mount modes: read-only (direct bind mount, shared inodes) or read-write (overlayfs layer).</li>
      </ol>
      <p><strong>Key benefit:</strong> Hardlinked files share page cache across pods. When one pod loads a shared
        library,
        other pods get cached pages. Container layers can't do this—each container gets separate inodes even with the
        same
        base image.</p>
      <p><strong>Comparison:</strong> Similar concept to nix-snapshotter, but doesn't require containerd modifications.
        Inspired Flox's "imageless Kubernetes" approach.</p>
      <p>Written in Python. In production use in hetzkube.</p>
    </details>
  </div>
</div>

<div class="nobreak-page">
  <h3><a href="https://github.com/lillecarl/easykubenix">easykubenix</a></h3>
  <div class="print-hide">
    <p>
      Kubernetes manifest generation using the NixOS module system. Composes
      cleanly, scales well, and lets you override with mkForce instead of JSON
      patches. Renders Helm charts into the module system for compatibility.
    </p>
    <details>
      <summary>Technical details</summary>
      <p><strong>Why:</strong> Helm templates are stringly-typed and hard to debug. Kustomize patches are
        limited—strategic merge works until it doesn't, JSON patches are verbose. The NixOS module system already solves
        configuration composition well.</p>
      <p><strong>Features:</strong></p>
      <ul>
        <li>Deep merging from multiple sources</li>
        <li>Type checking with clear errors</li>
        <li>Override at any level with <code>mkForce</code>/<code>mkOverride</code></li>
        <li>Conditional configuration with dependency tracking</li>
      </ul>
      <p><strong>Helm compatibility:</strong> Renders Helm charts and imports results into the module system. Override
        rendered resources like any other. Covers most use cases, though some hooks/lifecycle features don't translate.
      </p>
      <p><strong>nix-csi integration:</strong> Reference Nix packages directly in manifests—nix-csi automatically
        identifies and pulls required store paths.</p>
      <p>In production use managing all hetzkube deployments: cert-manager, Cilium, kube-prometheus-stack, Keycloak, and
        applications.</p>
    </details>
  </div>
</div>

<div class="nobreak-page">
  <h3><a href="https://github.com/lillecarl/hetzkube">hetzkube</a></h3>
  <div class="print-hide">
    <p>
      LARPing production-grade Kubernetes on Hetzner on a strict budget. Full platform: ClusterAPI
      control plane, NixOS nodes, Cilium with Gateway API, custom IPAM for IPv4/IPv6 LoadBalancer address reuse,
      enforced
      dual-stack via Kyverno, kube-prometheus-stack, and OIDC authentication via Keycloak across all services.
    </p>
    <details>
      <summary>Technical details</summary>
      <p><strong>Stack:</strong></p>
      <ul>
        <li><strong>Control plane:</strong> ClusterAPI managed CX22 node(s).</li>
        <li><strong>Workers:</strong> NixOS nodes rebuilt from scratch on every initialization.</li>
        <li><strong>Networking:</strong> Cilium for CNI, ingress, Gateway API and network policies. Full dual-stack
          (IPv4+IPv6) enforced via Kyverno.</li>
        <li><strong>Custom IPAM:</strong> Reuses node IP addresses as LoadBalancer addresses to avoid Hetzner floating
          IP/LB costs. Each node's /64 IPv6 block is carved up for services. Kyverno enforces IP sharing annotations to
          maximize IPv4 utilization.</li>
        <li><strong>Storage:</strong> hetzner-csi for traveling volumes, local-path-provisioner for node-bound volumes.
        </li>
        <li><strong>Observability:</strong> kube-prometheus-stack (Prometheus, Grafana, Alertmanager).</li>
        <li><strong>Auth:</strong> Keycloak OIDC for all! (Kube, Grafana, Headlamp, pgAdmin, ...)</li>
      </ul>
      <p><strong>Deployed components:</strong></p>
      <ul class="tags">
        <li>cert-manager</li>
        <li>Cilium</li>
        <li>CloudnativePG</li>
        <li>CoreDNS</li>
        <li>external-dns</li>
        <li>external-secrets</li>
        <li>Gateway API</li>
        <li>Headlamp</li>
        <li>Keycloak</li>
        <li>kube-prometheus-stack</li>
        <li>Kyverno</li>
        <li>metrics-server</li>
        <li>pgAdmin</li>
        <li>Vertical Pod Autoscaler</li>
      </ul>

      All manifests generated via easykubenix. Application delivery via nix-csi.
    </details>
  </div>
</div>

<div class="nobreak-page">
  <h3>Crossfaction Battlegrounds (World of Warcraft)</h3>
  <div class="print-hide">
    <p>
      First public implementation of crossfaction PvP queuing for World of Warcraft
      private servers (~2012). Balanced queue times between factions by allowing
      mixed-faction teams. Implemented multiple queue modes including item-level
      balancing and FIFO. Still used by private servers today, and the concept was later
      adopted by Blizzard as an official feature.
    </p>
    <details>
      <summary>Technical details</summary>
      <p><strong>Problem:</strong> WoW factions (Alliance/Horde) had imbalanced PvP populations. On private servers,
        80/20
        splits meant 30+ minute queues for one faction, instant for the other.</p>
      <p><strong>Implementation (C++):</strong></p>
      <ul>
        <li>Reused arena faction field to temporarily assign players to opposite faction during battlegrounds</li>
        <li>Invalidated Player info cache to all BG players</li>
        <li>Faked faction responses in player info cache packets</li>
        <li>Modified scoreboard packets so client UI displayed teams correctly</li>
        <li>Queue modes: simple (first-come-first-served) and item-level balanced (with gear-swap prevention)</li>
      </ul>
      <p><strong>Impact:</strong> Published publicly—first implementation any server could use. Spread rapidly across
        the
        private server community during the 3.3.5a era when faction imbalance was severe. Still in use today.</p>
      <p>Blizzard later added crossfaction instances to retail WoW (dungeons/raids first, then battlegrounds). The
        concept
        was proven on private servers years earlier.</p>
      <p>One of my first real programming projects—modifying a large C++ codebase to solve a problem affecting thousands
        of players.</p>
    </details>
  </div>
</div>

<div class="nobreak-page print-hide">
  <h3>Other</h3>
  <ul>
    <li><a href="https://github.com/lillecarl/dinix"><strong>dinix</strong></a> - Render dinit service configurations
      using Nix</li>
    <li><a
        href="https://github.com/lillecarl/registry/commit/96e3e3120f200dbf0c83cad2e2a3448f1acd0d8e"><strong>registry</strong></a>
      - Nix derivations for all OpenTofu registry providers</li>
    <li><strong>RC-Butiken</strong> - C# sync daemon for 20,000+ SKUs from supplier to Shopify. SQLite state tracking
      with
      daily diffing to handle API rate limits. Built inventory/price change reports for strategic ordering and crawled
      Traxxas.com for spare parts categorization.
      <details>
        <summary>Technical details</summary>
        <p><strong>Problem:</strong> Swedish RC hobby shop needed automated product catalog management. 20,000+
          products, Shopify API rate limits, daily supplier updates.</p>
        <p><strong>Architecture:</strong></p>
        <ul>
          <li>SQLite state tracking: store last-synced state, diff against daily supplier data, push only changes.
            Reduced daily API calls from 20,000+ to a few hundred.</li>
          <li>Selective sync: inventory/prices updated daily, images/descriptions imported once then shop-maintained.
          </li>
          <li>Daily reports: inventory changes, price changes, new products—enabled strategic ordering decisions.</li>
        </ul>
        <p><strong>Traxxas crawler:</strong> Scraped Traxxas.com parts catalog to extract car model → category → part
          relationships. Generated tags/categories for Shopify products. Bootstrapped better spare parts browsing UX.
        </p>
        <p>Ran reliably for years with minimal maintenance.</p>
      </details>
    </li>
  </ul>
</div>

<div class="print-only">
  <p>
    <small>This CV is compacted for print. Expandable technical details and additional projects are hidden. For the full interactive version with all details, visit <a href="https://lillecarl.com/cv">lillecarl.com/cv</a></small>
  </p>
</div>
