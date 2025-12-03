FROM frappe/bench:latest

# ====== المتغيرات القادمة من docker-compose (.env) ======
ARG FRAPPE_BRANCH
ARG ERPNEXT_REPO
ARG ERPNEXT_BRANCH
ARG BARONAPP_REPO
ARG BARONAPP_BRANCH

# أولاً نعمل root لتثبيت redis-server (مطلوب أثناء bench init)
USER root

RUN apt-get update \
    && apt-get install -y redis-server \
    && rm -rf /var/lib/apt/lists/*

# نرجع لمستخدم frappe حتى يعمل bench بالبيئة الصحيحة
USER frappe

# نستخدم /workspace كحاوية للـ bench
WORKDIR /workspace

# ====== إنشاء bench جديد داخل /workspace/frappe-bench وتنزيل ERPNext (+ baronerp لو موجود) ======
RUN bench init \
      --frappe-branch ${FRAPPE_BRANCH} \
      --skip-assets \
      --skip-redis-config-generation \
      frappe-bench \
    && cd frappe-bench \
    && bench get-app --branch ${ERPNEXT_BRANCH} ${ERPNEXT_REPO} \
    && if [ -n "${BARONERP_REPO}" ]; then \
         bench get-app --branch ${BARONERP_BRANCH} baronerp ${BARONERP_REPO}; \
       fi \
    && echo "{}" > sites/common_site_config.json

# الـ bench الحقيقي هنا
WORKDIR /workspace/frappe-bench

# Volumes للـ sites والـ logs (الـ assets داخل sites)
VOLUME [ \
  "/workspace/frappe-bench/sites", \
  "/workspace/frappe-bench/logs" \
]

EXPOSE 8000

# للتبسيط: نستخدم bench start (مقبول لبيئة إنتاج صغيرة)
CMD ["bench", "start"]
