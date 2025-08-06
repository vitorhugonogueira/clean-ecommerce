# clean_ecommerce

Um projeto Flutter de um protótipo de e-commerce aplicando princípios da Arquitetura Limpa.

_Publicado em: [clean-ecommerce.vercel.app](https://clean-ecommerce.vercel.app/)._

## Escopo

- Telas:
    - **Listagem de produtos**
    - **Detalhes do produto**
    - **Carrinho**
- Casos de uso que podem trazer complexidade (regras de negócio) ao front-end:
    - **Controle de estoque considerando o carrinho atual** (não persistido remotamente).
    - **Controle de navegação condicionada** (Ex: navegar para o carrinho ou permanecer na tela de detalhes após inclusão no carrinho).
    - **Tratamento de erros**.
- **Testes unitários** para o domínio da aplicação.
- Construir a UI com diferentes estratégias de gerenciamento de estado para demonstrar a flexibilidade de uma arquitetura limpa:
    - <font color="darkviolet">setState</font>
    - <font color="green">Provider</font>
    - <font color="brown">Bloc</font>
    - <font color="blue">Provider (MVVM)</font>

## Introdução

Com a **evolução do hardware** em nossos dias, a capacidade de processamento das aplicações front-end aumentou.
Isso nos levou a construirmos aplicações cada vez mais poderosas no front, com regras pesadas de gerenciamento
de estado, temas e funcionalidades especiais controladas exclusivamente no front-end. Mas, como toda virtude
tem seu preço, muitos de nossos aplicativos se tornaram **complexos demais**, legados e pouco escaláveis - sem falar na eterna dificuldade de escrever testes unitários combinados aos nossos componentes e telas.

Com base na minha experiência no front (7 anos) e no que tenho aprendido na leitura de Clean Architecture (Uncle Bob) e aplicação em projetos reais, gostaria de propor este **design de software** como um possível caminho para o desenvolvimento leve e escalável no front/mobile.

## Arquitetura

A arquitetura limpa propõe uma estrutura de camadas concêntricas com uma regra específica de direção de dependência. Tudo é feito para que o código seja **testável**. Sobre isso já estamos cientes e, se você não estiver, pode pesquisar mais sobre essa proposta arquitetural. Porém, sabemos também dos riscos: o temido **OVER ENGINEERING**. Sim, isso é um fato e, ao tentar aplicar a arquitetura limpa exatamente com todas as camadas
como manda o manual, com uma equipe num projeto real, a coisa não funcionou bem.

Por isso, quero deixar aqui uma proposta simplificada, que remove a necessidade (regra bruta) de se separar
as camadas contidas no domínio: Entidades e Casos de Uso. Com "regra bruta" quero dizer que não será obrigatório, não haverá um limite arquitetural entre as estruturas do domínio: entidades e casos de uso. O que não impede de separar essas responsabilidades e buscar, como **boa prática**, que casos de uso dependam de entidades, e não o inverso.

Além disso, os adaptadores de interface (presenters/gateways) são divididos em representações abstratas no
domínio e representações concretas na UI (Frameworks and Drivers). De modo que nossa aplicação terá **apenas 1 limiar arquitetural**: domínio <-> frameworks and drivers.

Dessa forma, não precisamos mais criar objetos DTO ou ViewModels para as entidades (por não poder acessar as entidades diretamente das telas), o que torna o processo muito custoso, sobretudo num contexto front-end. Ainda assim, não perdemos a testabilidade e a completa **independência do domínio**: onde residirão todas as regras de negócio da nossa aplicação. Abrindo espaço para outras regras potencialmente complexas do front: Regras de UI (constraints de tela, temas, condicionais para sistemas operacionais) e Regras de Dados (mapeamento de dados do back-end). Separar as regras de negócio melhora a organização, torna o código testável a nível de negócio e facilita enxergarmos as regras próprias de UI e Dados:

![Arquitetura](/architecture.jpg "Arquitetura")

### UI/Dados

- São os dois setores da camada de "Frameworks and Drivers", que aqui podemos chamar de "camadas" para facilitar, mesmo entendendo que elas estão no mesmo "degrau/camada" - ou seja, estão lado a lado.
- Isso significa que UI <> Dados se conhecem. Isso não significa que a tela deve utilizar diretamente Dados para buscar os produtos e preencher a tela, mas significa que a tela sabe de onde vem a informação e pode passar ao domínio o que ele não sabe (qual repositório ele usará para buscar os produtos). Ou seja, a tela conhece do DataSource apenas para passá-lo por parâmetro ao caso de uso - respeitando a separação de responsabilidades.

### Domínio

- Contém toda a regra de negócio - casos de uso / entidades.
- Contém toda a abstração do mundo exterior:
    - Gateways (dialog/navigator)
    - Repositórios.
    - Presenters/States.