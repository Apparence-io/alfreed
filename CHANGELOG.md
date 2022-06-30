## 0.4.0
- AlfreedPage get alfreedpageBuilder is now build()
- get viewmodel from any alfreedPage child
- fix lint errors
- 

## 0.3.0
- Remove unnecessary null check

## 0.2.4
- hot reload page builder when page is embedded inside a state

## 0.2.3
- hot reload prevent call onInit by default
- add onReassemble callback on presenter

## 0.2.2
- now reload viewinterface when pagebuilder is called again

## 0.2.1
- web support - removed dart:io from imports

## 0.2.0
- adding rebuildIfDisposed on AlfreedPageBuilder. Persist state even if page is rebuilt.  

## 0.1.0
- fixing hot reload. Add a AlfreedPage widget to embedd your builder. This is optionnal and only to handle hot reload correctly. 

## 0.0.3
- fix onInit called again when push back page

## 0.0.2
- pass arguments from routing directly to your presenter (see README)

## 0.0.1
- Alfreed first version
