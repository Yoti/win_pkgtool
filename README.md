# win_pkgtool
Набор скриптов, упрощающих работу с игровыми файлами (GPLv3)

## pkgtool - описание
Скрипт для автоматической загрузки PKG файла из базы **NoPayStation**, его распаковки,
а также дальшейшей дешифровки от PFS.
На данный момент применим только для тех PKG, у которых есть полный комплект из
ссылки и ложной лицензии в виде строки zRIF.
Скрипт активно использует сторонние приложения, подробнее описано далее.

## pkgtool - подготовка
Необходимо загрузить комплект из скриптов и программ в разделе [Releases](https://github.com/Yoti/win_pkgtool/releases/latest).
После чего выбрать какую-либо папку, желательно без русских букв в пути включительно.
Неплохим примером будет, к примеру, "D:\pkgtool" (распакуйте туда содержимое архива).
В подпапку "!bin" (полный путь из примера - "D:\pkgtool\\!bin") необходимо добавить:
* **wget** https://eternallybored.org/misc/wget/

На странице выбрать последнюю версию (на данный момент 1.19.4) и во втором столбце
с пометкой "32-bit binary" выбрать файл "wget.exe".
* **pkg2zip** https://github.com/mmozeiko/pkg2zip/releases

На странице выбрать последнюю версию (на данный момент 1.8), скачать архив
"pkg2zip_32bit.zip" и распаковать всё его содержимое.
* **psvpfsparser** https://github.com/motoharu-gosuto/psvpfstools/releases

На странице выбрать последнюю версию (на данный момент 2.0), скачать архив
"release_win32_xp.zip" и скопировать **содержимое папки** "release_win32_xp"
**внутри архива**.

## pkgtool - использование
Открыть командную строку в рабочей папке и выполнить команду `pkgtool TITLE_ID`.
Например, `pkgtool PCSB00952`. Подтвердить выполнение нажатием на **Enter**.
Скрипт самостоятельно загрузит свежую версию базы данных **NoPayStation**,
найдёт в ней соответствующую данному TITLE_ID строку, вычленит оттуда ссылку и
ложную лицензию, загрузит PKG файл на ПК. После чего, вторым шагом, PKG будет
распакован в подходящем для установки на игровую систему виде (т.н. NoNpDrm),
а третьим шагом подготовит ещё одну копию без PFS для изучения содержимого.
Соответственно, на жёстком диске необходим тройной объём для файла PKG и папок.
Все получившиеся файлы и папки будут располагаться в папке "app" внутри рабочей
папки. Работа скрипта при неполных данных в базе **NoPayStation** не тестировалась.

## dopatch
Аналогичный предыдущему скрипт, только предназначенный для работы с обновлениями.
Подготовка и использование полностью совпадают с основным скриптом.
Принцип работы немного отличается в тех моментах, что ссылка на обновление (патч)
получается напрямую с сервера платформодержателя, но ложная лицензия для снятия PFS
по-прежнему берётся у соответствущей игры из базы данных **NoPayStation**.

## mypatch
Скрипт автоматической подготовки структуры папок самодельного обновления
для программного обеспечения версии 3.61 и ниже. Работает только с имеющимися
распакованными играми, с учётом наличия распакованного официального обновления.

## Изменения
* 2018.05.15 - v1.0 (первый релиз)
* 2018.05.18 - v2.0 (работа с обновлениями)
* 2018.05.18 - v2.1 (убрана потребность в правах администратора)
* 2018.05.18 - v3.0 (скрипт самодельных обновлений для 3.61 и ниже)
* 2018.05.18 - v3.1 (изменена структура папок, подробнее в README.md)
* 2018.08.03 - v4.0 (обновлены скрипты и программы, а также README.md)
