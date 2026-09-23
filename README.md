# Programação para Dispositivos Móveis — 2026/2

Repositório de materiais e códigos da disciplina **Programação para
Dispositivos Móveis**, do 6º período do **Bacharelado em Sistemas de
Informação** do **Instituto Federal Goiano — Campus Ceres**.

> Prof. Dr. Paulo César Ferreira Melo · `paulo.melo1@ifgoiano.edu.br`

Ao longo do semestre construímos, juntos, um aplicativo real: o
**Caderno de Campo do Vale** — um registro de atividades agrícolas pensado
para produtores e cooperativas da região de Ceres e do Vale de São
Patrício. Cada aula acrescenta uma peça a esse app, em vez de exemplos
soltos e descartáveis.

---

## Como este repositório se organiza

Uma pasta por aula. Cada uma tem seu próprio `README.md` com o roteiro, as
atividades e as instruções para rodar.

| Pasta | Aula | Conteúdo |
|---|---|---|
| `ambiente/` | — | Tutoriais de instalação (Windows, macOS, Linux) |
| `aula-01-dart-fundamentos/` | 01 | Dart essencial: tipos, null safety, coleções, funções |
| `aula-02-dart-atividades/` | 02 | Oficina de Dart em ciclos (preveja, desafio, refatoração, caça-bug) |
| `aula-03-widgets-layout/` | 03 | **Widgets de layout: primeira tela no VS Code** |

> As aulas seguintes (estado e formulários, navegação, dados e persistência)
> serão adicionadas como novas pastas ao longo do semestre.

---

## Do DartPad ao VS Code

As duas primeiras aulas são de **linguagem Dart** e rodam inteiras no
**[dartpad.dev](https://dartpad.dev)**, sem instalar nada. A partir da
**aula 03**, passamos a construir telas de verdade e o trabalho migra para
o **VS Code com o Flutter instalado** — é quando o ambiente local deixa de
ser opcional.

Se você ainda não configurou o ambiente, comece pelos tutoriais na pasta
`ambiente/`, escolhendo o do seu sistema operacional. Confirme com:

```bash
flutter doctor
```

---

## Como usar o repositório

Clone uma vez:

```bash
git clone <url-do-repositorio>
cd prog-moveis-2026-2
```

Cada aula explica, no seu próprio `README.md`, como rodar aquele material.
Para as aulas com projeto Flutter, o padrão é:

```bash
cd aula-03-widgets-layout/projeto-inicial
flutter create .      # gera as pastas nativas (só na 1ª vez)
flutter pub get       # baixa as dependências
flutter run           # roda no dispositivo selecionado
```

> **Por que rodar `flutter create .`?** Os projetos aqui **não versionam** as
> pastas nativas (`android/`, `ios/`…) nem a `build/`, porque elas são
> geradas por máquina e mudam de um computador para outro. O comando as
> recria localmente. O que o repositório guarda é o essencial: o `lib/`
> (seu código) e o `pubspec.yaml` (as dependências).

---

## Estrutura de uma aula com projeto

As aulas de código seguem sempre o mesmo desenho, para você saber onde
procurar cada coisa:

```
aula-XX-nome/
├── README.md            roteiro e instruções da aula
├── exercicios/          arquivos .dart soltos (estudo e DartPad)
├── projeto-inicial/     projeto Flutter no estado zero — onde a aula acontece
└── projeto-gabarito/    o projeto com a solução pronta (liberado após a aula)
```

Os **exercícios soltos** servem para estudar e para o plano B no DartPad.
O **projeto-inicial** é onde você constrói, no VS Code. O **projeto-gabarito**
é a referência, liberada depois.

---

## Convenções

- **Identificador do app:** `br.edu.ifgoiano.ceres.caderno_campo`
- **Flutter:** canal `stable` (referência: 3.44). **Dart:** 3.12.
- **Dados de exemplo:** sempre do contexto regional — talhões, culturas
  (soja, milho, sorgo), cotação da saca, alqueire goiano (4,84 ha).
- **Cor institucional:** verde IF Goiano (`#1E5631`).

---

## Dúvidas e problemas de ambiente

Travou na instalação ou em algum comando? Anote a **etapa** e a **mensagem
de erro exata** e traga na aula ou pelo Moodle. Resolver um erro de
configuração é uma competência tão real quanto escrever código — e ninguém
precisa passar por isso sozinho.
