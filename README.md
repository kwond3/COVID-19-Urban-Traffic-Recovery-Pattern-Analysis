# COVID-19 Urban Traffic Recovery Pattern Analysis

**BigQuery · SQL · Looker Studio**

COVID-19 팬데믹 전후 도시별 교통 혼잡도 데이터를 분석하여, 도시마다 교통량이 얼마나 감소했고 이후 어느 정도까지 회복되었는지를 비교한 데이터 분석 프로젝트입니다.

단순히 교통량의 증감만 비교하는 것이 아니라, **Baseline과 저점(Trough)을 기준으로 서로 다른 회복 지표를 설계**하여 도시별 회복 패턴을 정량적으로 비교했습니다.

---

## 1. Project Overview

### Objective

COVID-19 이후 도시별 교통 혼잡도가 어떻게 변화하고 회복되었는지 분석하고,

- 도시별 충격의 크기는 얼마나 달랐는가?
- 저점 이후 얼마나 빠르게 반등했는가?
- COVID-19 이전 수준까지 실제로 회복했는가?
- 하나의 지표만으로 도시의 회복 수준을 판단해도 되는가?

를 데이터로 확인했습니다.

### Analysis Period

**2020.01 – 2022.03**

### Scope

- 8개 도시
- 시간 단위 Traffic 데이터
- 주간 평균으로 집계하여 도시별 추세 비교

---

## 2. Analysis Process

```text
Raw Traffic Data
       ↓
Data Cleaning & Aggregation
       ↓
Weekly Average Traffic
       ↓
Baseline / Trough Identification
       ↓
Recovery Metrics Design
       ↓
City-level Comparison
       ↓
Insight Extraction
       ↓
Looker Studio Dashboard
```

---

## 3. Metrics

도시별 회복 수준을 하나의 지표로 판단하는 데 한계가 있다고 보고, 서로 다른 기준점을 사용하는 3개의 지표를 설계했습니다.

### ① Drop %

COVID-19 이전 기준 대비 교통량이 얼마나 감소했는지를 측정합니다.

**목적:** 초기 충격의 크기 비교

---

### ② Increase %

COVID-19 이후 저점(Trough)에서 교통량이 얼마나 반등했는지를 측정합니다.

**목적:** 저점 이후의 반등 정도 비교

---

### ③ Recovery vs. Baseline

저점 이후 교통량이 COVID-19 이전 기준 수준에 얼마나 가까워졌는지를 측정합니다.

**목적:** 단순 반등이 아닌 실질적인 회복 수준 비교

---

## 4. Key Findings

### Recovery metrics can tell different stories

도시별 회복 수준을 비교한 결과, **반등률과 완전회복도 순위가 일치하지 않는 현상**을 확인했습니다.

- **Atlanta**는 반등률이 **90%+로 1위**였지만 완전회복도는 하위권에 위치
- **New York**은 반등률이 **5위**였음에도 완전회복도는 **90%+로 1위**

이는 동일한 도시의 교통 회복을 보더라도 **어떤 기준점을 사용하느냐에 따라 회복 수준에 대한 해석이 달라질 수 있음**을 보여줍니다.

따라서 도시별 회복 수준을 평가할 때 단일 지표만 사용하는 것보다, **초기 충격의 크기와 저점 이후 반등, 기존 수준 대비 회복 정도를 함께 고려하는 것이 중요**하다고 판단했습니다.

---

## 5. Data Quality Check

분석 과정에서 산업별 Traffic 데이터를 추가로 활용하려 했으나, 데이터 결측 문제를 확인했습니다.

단순히 결측값을 보정하여 분석을 진행하기보다 데이터 출처와 구조를 확인하여 결측 발생 원인을 검토했고, 분석의 신뢰성을 확보하기 위해 해당 분석을 최종 결과에서 제외했습니다.

이를 통해 분석 결과뿐 아니라 **데이터의 품질과 분석 가능 여부를 먼저 검증하는 과정**의 중요성을 확인했습니다.

---

## 6. Dashboard

분석 결과는 Looker Studio를 활용하여 도시별 Traffic 변화와 회복 지표를 시각화했습니다.

### Dashboard includes

- 도시별 Traffic 추세
- COVID-19 이전 Baseline
- 도시별 Trough
- Drop %
- Increase %
- Recovery vs. Baseline
- 도시별 회복 수준 비교

> **Looker Studio Dashboard:** [Dashboard Link]

---

## 7. Tools

| Category | Tools |
|---|---|
| Data Processing | BigQuery |
| Query | SQL |
| Visualization | Looker Studio |
| Analysis | Baseline / Trough / Recovery Metrics |

---

## 8. Repository Structure

```text
covid-traffic-recovery-analysis/
│
├── README.md
│
├── sql/
│   └── traffic_analysis.sql
│
├── report/
│   └── covid_traffic_analysis.pdf
│
└── dashboard/
    └── dashboard_screenshot.png
```

원본 데이터는 저장하지 않고, 데이터 출처와 분석에 사용한 테이블 및 SQL을 repository에 정리했습니다.

---

## 9. What I Learned

이 프로젝트를 통해 단순한 데이터 조회를 넘어,

1. 문제를 분석 가능한 단위로 정의하고
2. 분석 목적에 맞는 지표를 직접 설계하며
3. SQL을 활용해 데이터를 가공하고
4. 데이터 품질 문제를 검증한 뒤
5. 결과를 시각화하고
6. 서로 다른 지표의 결과를 비교하여

**데이터에서 의미 있는 Insight를 도출하는 전체 분석 과정**을 경험했습니다.
