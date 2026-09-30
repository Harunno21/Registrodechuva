# 🌧️ Caderno de Campo do Vale — Registro de Chuva

Pluviômetro digital feito em Flutter. O produtor anota a chuva medida a cada dia e o app mostra, na hora, o **acumulado** e a **média** do período.

---

## 1. O que o app faz

1. O usuário informa a **data** da medição e os **milímetros** de chuva.
2. Ao tocar em **Registrar chuva**, a leitura entra numa lista.
3. O app recalcula automaticamente o **total acumulado** e a **média** das leituras.
4. Valores **negativos** ou **não numéricos** são recusados, com mensagem explicando o motivo.
5. Cada leitura pode ser removida individualmente, ou a lista inteira pode ser limpa.

### Regras de validação

| Situação | Comportamento |
|---|---|
| Data em branco | Recusa: "Informe a data da medição." |
| Chuva não numérica (ex.: `abc`) | Recusa: "Informe um valor numérico válido para a chuva." |
| Chuva negativa (ex.: `-5`) | Recusa: "O valor da chuva não pode ser negativo." |
| Chuva válida (ex.: `12,5` ou `12.5`) | Aceita e atualiza os cálculos |

O campo aceita **vírgula ou ponto** como separador decimal, já que o produtor brasileiro costuma digitar `12,5`.

### Exercita

Formulário · validação · lista · cálculo agregado com `fold` · estado (`setState`)

---

## 2. Como rodar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (Material 3, versão estável recente)
- Um emulador Android/iOS, um celular conectado, ou Chrome para rodar na web

Confira a instalação:

```bash
flutter doctor
```

### Passo a passo

```bash
# 1. Crie (ou abra) um projeto Flutter
flutter create caderno_do_vale
cd caderno_do_vale

# 2. Substitua o conteúdo de lib/main.dart pelo main.dart deste projeto

# 3. Baixe as dependências
flutter pub get

# 4. Rode o app
flutter run
```

Para escolher onde rodar (celular, emulador ou navegador):

```bash
flutter devices
flutter run -d chrome
```

O projeto usa apenas pacotes do próprio Flutter (`material.dart` e `services.dart`), então **não precisa instalar dependências extras**.

---

## 3. Estrutura do código

Tudo está em um único arquivo, `lib/main.dart`:

| Componente | Função |
|---|---|
| `CadernoDoValeApp` | Configura o `MaterialApp` e o tema verde (Material 3). |
| `_DataInputFormatter` | Coloca as barras da data automaticamente (`DD/MM/AAAA`) enquanto a pessoa digita. |
| `RegistroChuva` | Modelo de uma leitura: `data` e `milimetros`. |
| `RegistroChuvaPage` / `_RegistroChuvaPageState` | Tela principal, com estado, cálculos e validação. |
| `_CardResumo` | Cartão reutilizado para mostrar Acumulado e Média. |

---

## 4. Quem fez o quê

| Integrante | Papéis |
|---|---|
| **Arthur** | Construtor + Designer de interface |
| **Janiele** | Relator |

### 🛠️ Arthur - Construtor (lógica e estado)

Responsável por como o app reage e pelas escolhas técnicas.

- **Estado com `StatefulWidget` e `setState`**: a lista de leituras (`_registros`), a mensagem de erro (`_erro`) e a mensagem de feedback do campo (`_mensagemChuva`) mudam durante o uso, então a tela precisa ser reconstruída a cada mudança.
- **Acumulado com `fold`**: o total é um getter que percorre a lista somando os milímetros.

  ```dart
  double get _totalChuva {
    return _registros.fold(
      0.0,
      (soma, registro) => soma + registro.milimetros,
    );
  }
  ```

  *Por quê getter?* Assim o valor nunca fica desatualizado: não existe uma variável "total" para esquecer de atualizar. Toda vez que a lista muda e a tela é reconstruída, o total e a média são recalculados a partir da fonte de verdade, que é a própria lista.
- **Média protegida contra divisão por zero**: se não há registros, retorna `0.0` em vez de dar erro.
- **Validação em dois momentos**:
  - *Enquanto digita* (`onChanged` → `_validarEnquantoDigita`): mostra na hora se o valor é válido, inválido ou negativo.
  - *Ao registrar* (`_adicionarRegistro`): revalida tudo antes de inserir. Se algo estiver errado, **nada entra na lista**.
- **Tratamento de vírgula decimal**: `replaceAll(',', '.')` antes de `double.tryParse`, que devolve `null` para texto não numérico, sem lançar exceção.
- **Máscara de data** (`_DataInputFormatter`): remove tudo que não é número, limita a 8 dígitos e insere as barras.
- **Limpeza de recursos**: os `TextEditingController` são liberados no `dispose()`.
- **Após registrar**: limpa os campos, zera a mensagem de erro e volta o texto de ajuda ao padrão.

### 🎨 Arthur - Designer de interface (layout e decisões de campo)

Duas decisões pensadas para o uso no campo, onde há sol forte, mãos sujas ou molhadas e pressa:

**Decisão 1 - Teclado e máscara certos para cada campo.**
O produtor não deveria precisar procurar números ou barras no teclado. O campo de data abre o teclado **numérico** e insere as barras sozinho (digitar `25092026` vira `25/09/2026`). O campo de chuva abre o teclado numérico **com decimal**. Menos toques, menos erros de digitação.

**Decisão 2 - Feedback de erro que não depende só de cor.**
O erro aparece em uma caixa própria com **ícone + texto + cor** (fundo rosa-claro, vermelho escuro `#C62828`), e o campo de chuva tem uma mensagem de apoio que muda enquanto se digita ("Leitura válida: 12,5 mm"). Sob luz forte ou para quem tem dificuldade de distinguir cores, o ícone e o texto continuam deixando claro o que aconteceu.

**Outras escolhas de layout:**

- **Hierarquia visual**: título grande em verde escuro → formulário → botão principal → resumo → lista. O fluxo natural é de cima para baixo: preencher, registrar, conferir.
- **Resultados em destaque**: Acumulado e Média em cartões lado a lado, com números em fonte grande (22) e negrito, que são a informação que o produtor mais quer ver.
- **Alvo de toque**: o botão "Registrar chuva" é largo (ocupa toda a largura) e com altura confortável (`padding` vertical de 16); o ícone de remover usa o `IconButton` padrão do Material, que respeita a área mínima de toque.
- **Contraste**: textos principais em verde muito escuro (`#1B5E20`) sobre fundo claro; ícones e bordas em verde mais claro só como apoio.
- **Estado vazio amigável**: "Nenhuma medição registrada ainda." evita uma tela em branco confusa.
- **Botão "Limpar" desativado** quando não há registros, para evitar toque sem efeito.
- **Rolagem** (`SingleChildScrollView`): a tela continua utilizável com o teclado aberto em celulares pequenos.

### 📝 Janiele - Relator (documentação e demonstração)

- Escreveu este **README** (visão geral, como rodar e divisão de papéis).
- Conduz a **demonstração ao vivo**, apresentando o app e dando a palavra ao Arthur para explicar a lógica e as decisões de interface.

---

## 5. Limitações conhecidas e próximos passos

- Os dados ficam **apenas em memória**: ao fechar o app, as leituras são perdidas. Próximo passo: salvar com `shared_preferences` ou um banco local.
- A data é tratada como **texto** e só é checada para não ficar vazia. Ela aceita, por exemplo, `99/99/9999`. Próximo passo: validar como data real e oferecer um seletor de calendário.
- A **média** é calculada por **leitura registrada**, não por dia do calendário. Se houver duas leituras no mesmo dia, cada uma conta separadamente.
- Não há edição de uma leitura existente, apenas remoção.
- Não há ordenação por data: a lista segue a ordem de inserção.

---

## 6. Tecnologias

- [Flutter](https://flutter.dev/) com Material 3
- Dart
