{% from "subversion/map.jinja" import subversion with context %}
include:
  - apache.mod_dav_svn
  - apache.utils

{{ subversion.package_name }}:
  pkg.installed:
    - refresh: True

{{ subversion.repo_parent_path }}:
  file.directory:
    - user: {{ subversion.user }}
    - group: {{ subversion.group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

{% if subversion.repo_name %}
create-{{ subversion.repo_name }}:
  cmd.run:
    - creates: {{ subversion.repo_parent_path }}/{{ subversion.repo_name }}
    - name: svnadmin create --fs-type fsfs {{ subversion.repo_parent_path }}/{{ subversion.repo_name }}
{% endif %}

{% if subversion.server %}
{{ subversion.server.apache_sites }}/{{ subversion.server.site_name }}.conf:
  file.managed:
    - source: salt://subversion/files/svn.conf
    - user: {{ subversion.user }}
    - group: {{ subversion.group }}
    - mode: 644
    - template: jinja
    - defaults:
        web_context: {{ subversion.server.web_context }}
        repo_parent_path: {{ subversion.repo_parent_path }}
        password_file: {{ subversion.server.password_file }}
  cmd.run:
    - name: a2ensite {{ subversion.server.site_name }}
  service.running:
    - name: {{ subversion.server.package_name }}
    - enable: True
    - reload: True
    - watch:
      - file: {{ subversion.server.apache_sites }}/{{ subversion.server.site_name }}.conf

{{ subversion.server.password_file }}:
  file.managed:
    - user: {{ subversion.user }}
    - group: {{ subversion.group }}
    - mode: 644
    - create: True
    - contents:
  cmd.run:
    - name: htpasswd -bm {{ subversion.server.password_file }} {{ subversion.server.user }} {{ subversion.server.password }}
{% endif %}

