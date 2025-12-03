FROM frappe/bench:latest

# ====== المتغيرات القادمة من docker-compose (.env) ======
ARG FRAPPE_REPO
ARG FRAPPE_BRANCH
ARG ERPNEXT_REPO
ARG ERPNEXT_BRANCH
ARG CUSTOM_APP_1_REPO
ARG CUSTOM_APP_1_BRANCH

# مكان العمل داخل الكونتينر
WORKDIR /workspace

# ====== إنشاء bench وتنزيل Frappe/ERPNext ======
RUN bench init --frappe-branch ${FRAPPE_BRANCH} --skip-assets /workspace \
    && cd /workspace \
    && bench get-app --branch ${ERPNEXT_BRANCH} ${ERPNEXT_REPO}

# ====== تنزيل التطبيق المخصص (اختياري) ======
RUN if [ -n "${CUSTOM_APP_1_REPO}" ]; then \
      cd /workspace && bench get-app --branch ${CUSTOM_APP_1_BRANCH} ${CUSTOM_APP_1_REPO}; \
    fi

# ====== فتح البورت 8000 (سنعمل reverse من 80 -> 8000 في docker-compose) ======
EXPOSE 8000
