FROM frappe/bench:latest

# ====== المتغيرات القادمة من docker-compose (.env) ======
ARG FRAPPE_REPO
ARG FRAPPE_BRANCH
ARG ERPNEXT_REPO
ARG ERPNEXT_BRANCH
ARG CUSTOM_APP_1_REPO
ARG CUSTOM_APP_1_BRANCH

# سنستخدم /workspace كحاوية عامة، وننشئ bench داخلها في مجلد فرعي
WORKDIR /workspace

# ====== إنشاء bench جديد داخل /workspace/frappe-bench وتنزيل ERPNext ======
RUN bench init --frappe-branch ${FRAPPE_BRANCH} --skip-assets frappe-bench \
    && cd frappe-bench \
    && bench get-app --branch ${ERPNEXT_BRANCH} ${ERPNEXT_REPO}

# ====== تنزيل التطبيق المخصص (اختياري) ======
RUN if [ -n "${CUSTOM_APP_1_REPO}" ]; then \
      cd /workspace/frappe-bench && bench get-app --branch ${CUSTOM_APP_1_BRANCH} ${CUSTOM_APP_1_REPO}; \
    fi

# نجعل الـ WORKDIR الافتراضي هو مجلد الـ bench نفسه
WORKDIR /workspace/frappe-bench

EXPOSE 8000
