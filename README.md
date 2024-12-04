# Smartlist

Smartlist é um projeto Flutter que serve como ponto de partida para o desenvolvimento de aplicativos móveis. Este projeto utiliza um design system modular para facilitar a criação de componentes reutilizáveis e consistentes.

## Visão Geral

O Smartlist é projetado para ser um aplicativo escalável e de fácil manutenção, com uma arquitetura bem definida e componentes de UI personalizáveis. Ele inclui exemplos de botões, estilos de texto e cores que podem ser facilmente adaptados para atender às necessidades do seu projeto.

## Estrutura do Projeto

- **lib/DesignSystem**: Contém todos os componentes de UI e estilos compartilhados.
  - **Components/Buttons**: Inclui botões personalizados como `ActionButton`.
  - **shared**: Contém cores e estilos de texto que são usados em todo o aplicativo.

## Componentes Principais

### ActionButton

O `ActionButton` é um componente de botão personalizável que suporta diferentes tamanhos e estilos. Ele é configurado através de um `ActionButtonViewModel`, que define propriedades como `size`, `style`, `icon`, e `text`.

#### Propriedades

- **size**: Define o tamanho do botão (`large`, `medium`, `small`).
- **style**: Define o estilo do botão (`primary`, `secondary`, `tertiary`).
- **icon**: Ícone opcional a ser exibido no botão.
- **text**: Texto a ser exibido no botão.

## Como Começar

Para começar a usar o Smartlist, siga estas etapas:

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/smartlist.git
   ```

2. **Navegue até o diretório do projeto**:
   ```bash
   cd smartlist
   ```

3. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

## Recursos Úteis

- [Lab: Escreva seu primeiro aplicativo Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Exemplos úteis de Flutter](https://docs.flutter.dev/cookbook)

## Documentação

Para mais informações sobre o desenvolvimento com Flutter, consulte a [documentação online](https://docs.flutter.dev/), que oferece tutoriais, exemplos, orientações sobre desenvolvimento móvel e uma referência completa da API.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
