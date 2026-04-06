# 🚀 DCFlexGrid

Um componente moderno de **Grid para Delphi** com suporte a **Master-Detail**, desenvolvido para facilitar a criação de interfaces mais profissionais e organizadas.

> ⚠️ **Status: Beta**  
> Este projeto ainda está em desenvolvimento.

---

## ✨ Recursos

* ✔ Suporte a **Master-Detail**
* ✔ Estrutura baseada em **Runtime + Design-time packages**
* ✔ API fluente para configuração rápida
* ✔ Temas visuais profissionais
* ✔ Regras visuais dinâmicas (Visual Rules)
* ✔ Integração com Delphi moderno (XE7+)
* ✔ Fácil instalação
* ✔ Pensado para evolução contínua

---

## 🆕 Novidades recentes

### 🎯 Visual Rules Designer

Novo recurso que permite aplicar regras visuais dinâmicas no grid.

✔ Definição de condições por campo  
✔ Operadores disponíveis:
- Equals
- Not Equals
- Contains
- Starts With
- Greater Than
- Less Than  

✔ Estilização automática:
- Cor de fundo  
- Cor da fonte  
- Estilo da fonte  

👉 Nesta primeira versão, as regras são aplicadas na **linha inteira**

```delphi
DCGrid1.ShowVisualRulesDesigner;
```

---

### 🐞 Correções

* Correção de bug na renderização de linhas
* Ajustes no comportamento do detail
* Melhorias gerais de estabilidade

---

## 🧰 Requisitos

* Delphi **XE7 ou superior**
* VCL (compatível com FMX dependendo da evolução do componente)
* Windows (Win32 / Win64)

---

## 📦 Instalação

### 1. Abrir o projeto

Abra o arquivo:

DCFlexGrid.groupproj

---

### 2. Compilar o Runtime

Clique com o botão direito em:

DCFlexGridR

E selecione:

Build

---

### 3. Instalar o Design-time

Clique com o botão direito em:

DCFlexGridD

E selecione:

Install

---

### 4. Configurar Library Path (IMPORTANTE)

Acesse:

Tools > Options > Delphi > Library

Adicione o caminho da pasta `src`:

...\DCFlexGrid\src

---

### 🔁 5. Reiniciar o Delphi (recomendado)

---

## 🎉 Resultado

Após a instalação:

* O componente estará disponível na paleta:

Delphi Creative

* Componente:

TDCFlexGrid

* Pronto para uso em seus formulários

---

## ⚡ Uso rápido (Fluent API)

```delphi
DCGrid1
  .ClearColumns
  .AddTextColumn('pedido', 'Pedido', 90)
  .AddTextColumn('cliente', 'Cliente', 180)
  .AddRightColumn('total', 'Total', 100)
  .WithProfessionalTheme;
```

---

## 🔗 Bind de dados

```delphi
DCGrid1.BindDataSets(qryOrders, qryItems, 'pedido', 'pedido');
```

---

## ⚠️ Problemas comuns

### ❌ Unit 'DCFlexGrid' not found

✔ Solução:

* Verifique se o `Library Path` foi configurado corretamente

---

### ❌ Componente não aparece na paleta

✔ Solução:

* Certifique-se de instalar o package **DCFlexGridD**
* Reinicie o Delphi

---

### ❌ Erro ao instalar

✔ Solução:

* Compile primeiro o `DCFlexGridR`
* Depois instale o `DCFlexGridD`

---

## 💡 Sobre o projeto

O DCFlexGrid foi criado com o objetivo de fornecer uma alternativa moderna para grids no Delphi, com foco em:

* Produtividade
* Organização de dados
* Experiência visual profissional
* Evolução contínua

---

## ❤️ Apoie o projeto

Se esse projeto te ajudou de alguma forma, considere apoiar 🙌

Sua contribuição ajuda na evolução do componente, melhorias e novos recursos.

💰 **Doações via Pix / PayPal (diegocataneo@outlook.com)**

---

## 📌 Roadmap (futuro)

* [ ] Regras por célula
* [ ] Regras por coluna
* [ ] Persistência de configurações do usuário
* [ ] Internacionalização
* [ ] Melhorias visuais avançadas
* [ ] Performance otimizada
* [ ] Mais recursos de Master-Detail
* [ ] Suporte expandido (FMX)
* [ ] Documentação completa

---

## 🧑‍💻 Autor

**Diego Cataneo**  
📺 YouTube: Delphi Creative  
💻 GitHub: https://github.com/DelphiCreative  

---

## 📄 Licença

Definir (MIT, comercial, etc.)

---

## ⚠️ Aviso

Este é um projeto em fase **beta**.  
Recomenda-se validar antes de utilizar em produção.

---

## ⭐ Contribuições

Contribuições são bem-vindas!

* Abra uma issue
* Sugira melhorias
* Reporte bugs
