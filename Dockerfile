FROM python:3.8-alpine as base

FROM base as builder

ENV PYTHONDONTWRITEBYTECODE 1

RUN pip install pipenv

# creation of requirements.txt
COPY Pipfile* ./
RUN pipenv lock -r > requirements.txt

# everything else stays the same
RUN pip install --no-cache-dir -r ./requirements.txt

FROM base
COPY --from=builder /usr/local/lib/python3.8/site-packages/ /usr/local/lib/python3.8/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

WORKDIR /code

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONPATH /code:$PYTHONPATH

COPY . ./