---
layout: page
title: "Standards & Frameworks"
permalink: /frameworks/
description: "The government and industry standards P-SSCRM was built from, and which P-SSCRM controls cite each one."
---

P-SSCRM was assembled by analysing and unifying the government and industry
standards below. Every P-SSCRM control cites one or more of them, so aligning
with P-SSCRM keeps you aligned with these sources.

{% assign fw_order = "eo,800-161,ssdf,ssdf-ai,self-attestation,slsa,bsimm,samm,cncf-ssc,s2c2f,osps,ossf-scorecard,owasp-scvs" | split: "," %}
<ul class="framework-index">
  {% for key in fw_order %}
    {% assign fw = site.data.frameworks[key] %}
    {% if fw %}
      <li>
        <h2>{% if fw.url %}<a href="{{ fw.url }}" target="_blank" rel="noopener">{{ fw.name }}</a>{% else %}{{ fw.name }}{% endif %}</h2>
        <p>{{ fw.full_name }}</p>
      </li>
    {% endif %}
  {% endfor %}
</ul>

## Which controls cite each standard

Expand a standard to see the P-SSCRM controls that map to it; each links to its
full entry on [The Framework]({{ "/framework/" | relative_url }}).

{% assign ordered_controls = "" | split: "" %}
{% assign _groups = site.groups | sort: "weight" %}
{% for g in _groups %}
  {% assign _practices = site.practices | where: "group", g.slug | sort: "weight" %}
  {% for p in _practices %}
    {% assign _cs = site.controls | where: "practice", p.slug | sort: "weight" %}
    {% assign ordered_controls = ordered_controls | concat: _cs %}
  {% endfor %}
{% endfor %}
<div class="reverse-map">
  {% for key in fw_order %}
    {% assign fw = site.data.frameworks[key] %}
    {% if fw %}
      <details>
        <summary>{{ fw.name }} <span class="reverse-map-full">{{ fw.full_name }}</span></summary>
        <ul class="child-list">
          {% for control in ordered_controls %}
            {% assign ref = control.frameworks[key] %}
            {% if ref %}
              <li><a href="{{ "/framework/" | relative_url }}#{{ control.slug }}">{{ control.code }} &mdash; {{ control.title }}</a> <span class="mapping-ref">{{ ref }}</span></li>
            {% endif %}
          {% endfor %}
        </ul>
      </details>
    {% endif %}
  {% endfor %}
</div>

{% if site.data.frameworks_pending and site.data.frameworks_pending.size > 0 %}
## Standards being added

<ul>
  {% for item in site.data.frameworks_pending %}<li>{{ item }}</li>{% endfor %}
</ul>
{% endif %}
