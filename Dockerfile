FROM frappe/bench:latest

# ====== المتغيرات القادمة من docker-compose (.env) ======
ARG FRAPPE_REPO
ARG FRAPPE_BRANCH
ARG ERPNEXT_REPO
ARG ERPNEXT_BRANCH
ARG CUSTOM_APP_1_REPO
ARG CUSTOM_APP_1_BRANCH

# مكان العمل داخل الكونتينر - في هذه الصورة /workspace هو bench جاهز
WORKDIR /workspace

# ====== تنزيل ERPNext على الـ bench الموجود ======
RUN cd /workspace \
    && bench get-app --branch ${ERPNEXT_BRANCH} ${ERPNEXT_REPO}

# ====== تنزيل التطبيق المخصص (اختياري) ======
RUN if [ -n "${CUSTOM_APP_1_REPO}" ]; then \
      cd /workspace && bench get-app --branch ${CUSTOM_APP_1_BRANCH} ${CUSTOM_APP_1_REPO}; \
    fi

EXPOSE 8000
