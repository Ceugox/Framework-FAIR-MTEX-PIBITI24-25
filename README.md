

---

# 📘 Coletânea de Códigos MTEX para Análise EBSD

**Autor:** Marcell Parra Araújo B. Silva
**Programa:** PIBITI 2024/2025
**Instituição:** Instituto Militar de Engenharia (IME)
**Tema:** Processamento e Interpretação de Caracterização Microestrutural

---

## 🧩 Descrição Geral

Este repositório contém um **framework de scripts MATLAB** desenvolvido com base no **MTEX 5.11.1**, voltado para **análise e visualização de dados EBSD (Electron Backscatter Diffraction)** e **XRD (Difração de Raios X)**.

O objetivo é **automatizar e padronizar o processamento microestrutural**, facilitando a obtenção de mapas, histogramas e figuras de polo a partir de dados cristalográficos indexados.

---

## 🧱 Estrutura do Framework

Cada categoria de código corresponde a uma etapa da análise EBSD/XRD:

| Categoria                              | Descrição                                                            | Arquivo(s) / Script(s)        |
| -------------------------------------- | -------------------------------------------------------------------- | ----------------------------- |
| **1. Carregamento e Visualização**     | Importação e visualização inicial dos dados EBSD (.ctf)              | `carregamento_visualizacao.m` |
| **2. Chaveamento de Cores (IPF)**      | Criação de chave de cores de orientação (IPF) para fases específicas | `ipf_color_key.m`             |
| **3. Mapa de Grãos**                   | Cálculo e suavização de grãos com limiar de desorientação ajustável  | `mapa_graos.m`                |
| **4. Tratamento e Suavização**         | Aplicação de filtros (halfQuadratic, median, spline)                 | `suavizacao.m`                |
| **5. Análise de Misorientação**        | Cálculo de misorientação média e plotagem de contornos               | `misorientacao.m`             |
| **6. Histograma de Tamanho de Grãos**  | Geração de histograma normalizado com média destacada                | `histograma_graos.m`          |
| **7. Figura de Polo, ODF e IPF**       | Análises para arquivos XRDML (DRX) e EBSD (.ctf)                     | `pole_odf_ipf.m`              |
| **8. Densidade de Discordância (GND)** | Cálculo da densidade de discordâncias (em desenvolvimento)           | `gnd_density.m`               |

---

## ⚙️ Requisitos

* **MATLAB** versão R2023a ou superior
* **MTEX Toolbox** (versão ≥ 5.11.1)
* Dados de entrada:

  * Arquivos `.ctf` (EBSD)
  * Arquivos `.xrdml` (difração de raios X)

---

## 🚀 Como Usar

1. **Instale o MTEX:**

   ```matlab
   mtexdoc install
   ```

2. **Adicione o diretório do framework ao MATLAB:**

   ```matlab
   addpath('C:\Caminho\para\Coletanea_MTEX');
   ```

3. **Carregue seus dados EBSD:**

   ```matlab
   ebsd = EBSD.load('meu_arquivo.ctf');
   ```

4. **Execute os scripts por etapa:**

   ```matlab
   run('mapa_graos.m');
   run('suavizacao.m');
   run('histograma_graos.m');
   ```

5. **Visualize os resultados:**
   As figuras serão exibidas automaticamente (orientações, grãos, histogramas, etc.).

---

## 📊 Resultados Gerados

* Mapas de orientação e grãos suavizados
* Chaves de cor IPF
* Histogramas de tamanho de grão
* Figuras de polo e IPF
* Cálculo de ODF (função de distribuição de orientação)
* Cálculo preliminar de densidade de discordância (GND)

---

## 🔬 Em Desenvolvimento

A categoria **8 (Densidade de Discordância)** está sendo aprimorada para materiais triclínicos, com cálculo detalhado do **tensor de Nye** e mapas logarítmicos de densidade de GND.

---

## 📁 Estrutura de Pastas Recomendada

```
Coletanea_MTEX/
│
├── dados/
│   ├── exemplo.ctf
│   ├── exemplo.xrdml
│
├── scripts/
│   ├── carregamento_visualizacao.m
│   ├── ipf_color_key.m
│   ├── mapa_graos.m
│   ├── suavizacao.m
│   ├── misorientacao.m
│   ├── histograma_graos.m
│   ├── pole_odf_ipf.m
│   └── gnd_density.m
│
└── README.md
```

---

## 🧠 Créditos e Referências

* **MTEX Toolbox:** [https://mtex-toolbox.github.io/](https://mtex-toolbox.github.io/)
* **Referência principal:** Hielscher, R., & Schaeben, H. *A novel pole figure inversion method: specification of the MTEX open-source toolbox.*
* **Supervisão:** Programa PIBITI – CNPq / IME

---

Deseja que eu gere esse README em formato **Markdown (.md)** pronto para GitHub (com emojis, cabeçalhos e blocos de código formatados) ou em **PDF técnico** para acompanhamento do relatório PIBITI?
