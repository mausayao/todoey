# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
### Changed
### Removed
### Fixed

## [0.4.2] - 2019-06-05
### Added
- Adicionado pod SwipeCellKit
- Adicionado super classe que encapsula os metodos swipecell
- CategoryViewController e TodoListViewController passam a herdar os metodos da classe SwipeTableViewController

## [0.4.1] - 2019-06-04
### Added
- Adicinado novo campo data de criaçao na classe Activity
- Filtro é ordenado por data de criação
### Fixed
- Warnings relacionado ao pod Realm

## [0.4.0] - 2019-06-03
### Added
- Adicionado Realm
- Realizado refatoração para usar o realm para persitencia de dados
### Removed
- CoreData

## [0.3.2] - 2019-06-02
### Added
- Adicionado nova view de categoria
- Adicionado salvar categoria
- Adicionado listar categoria
- adicionado segue para atividades
- adicionado relacionamento de atividades com categorias
- ajustes para salvar atividade com categorias


## [0.3.1] - 2019-06-01
### Added
- Adicionado pesquisar


## [0.3.0] - 2019-06-01
### Added
- Salvar Activity 
- Listar Activity
- Adicionado CoreData
### Removed
-  FileManager
-  Model Activity

## [0.2.1] - 2019-05-29
### Added
- Model Activity
- FileManager
- Arquivo com atividades salvas
### Removed
-  UserDefault

## [0.2.0] - 2019-05-28
### Added
- Adicionado persistencia utilizando o UserDefaults da lista de atividades
- Adicionado carregar lista de atividades 

## [0.1.0] - 2019-05-27

### Added
- Adicionado tabble view
- Adicionado metodos para exibir os dados 
- Adicionado metodo para adicionar ou remover check ao selecionar uma celula
- Adicionado metodo para adicionar nova atividade
- Projeto organizado para o padrão MVC
