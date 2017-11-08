# Elm-phoenix-chat

# Dev dependencys

## Install deps
- npm run reinstall

## Run dev server with template model
- npm run start:template

### Accessing
- http://localhost:8080/index-template.html

## Build 'dist' with template model
- npm run build:template

## Run dev server without template model
- npm run start

## Build 'dist' without template model
- npm run build


# ELM project structure

```
src
  |── App.elm
  |── Types.elm  " Main app types"
  |── State.elm " Main update and initial Model state"  
  |── View.elm " Main view elm file"
      |──> Views " Dir with all components views/ views helpers ex: Tabs, btns"
  ├── Styles
      |──> General.elm " General inline styles / css utilities "
  ├── Rest.elm "All fn relatives to Rest api"
  |── Data.elm "All json decoders for types"
  |── Phx " All phoenix fn's"
      |──> Phx " Helpers for phx module and actions"
      |──> Phx " Msg / other types relative to phx"
  |── CustomEvents " Helpers for custom dom events"
```
