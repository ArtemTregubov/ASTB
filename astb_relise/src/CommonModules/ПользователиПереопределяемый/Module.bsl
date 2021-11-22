////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет стандартное поведение подсистемы Пользователи.
//
// Параметры:
//  Настройки - Структура - со свойствами:
//   * ОбщиеНастройкиВхода - Булево - начальное значение Истина, если установить Ложь,
//          тогда в панели администрирования "Настройки прав и пользователей" возможность
//          открытия формы настроек входа будет скрыта, как и настройка ограничения срока действия
//          в карточках пользователя и внешнего пользователя. Для базовых версий конфигурации всегда Ложь.
//
//   * РедактированиеРолей - Булево - начальное значение Истина, если установить Ложь, тогда
//          интерфейс изменения ролей в карточках пользователя, внешнего пользователя и
//          группы внешних пользователей будет скрыт (в том числе для администратора).
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Позволяет указать роли специального назначения. Все остальные роли не требуется указывать -
// это роли, которые предназначены для любых пользователей, кроме внешних пользователей.
//
// Параметры:
//  НазначениеРолей - Структура - со свойствами:
//   * ТолькоДляАдминистраторовСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для администраторов сервиса, например:
//       Администрирование, ОбновлениеКонфигурацииБазыДанных, АдминистраторСистемы,
//     а также все роли с правами:
//       Администрирование,
//       Администрирование расширений конфигурации,
//       Обновление конфигурации базы данных.
//     Такие роли, как правило, существуют только в БСП и не встречаются в прикладных решениях.
//
//   * ТолькоДляПользователейСистемы - Массив - имена ролей, которые при выключенном разделении
//     предназначены для любых пользователей, кроме внешних пользователей, а в разделенном режиме
//     предназначены только для неразделенных пользователей (сотрудников технической поддержки сервиса и
//     администраторов сервиса), например:
//       ДобавлениеИзменениеАдресныхСведений, ДобавлениеИзменениеБанков,
//     а также все роли с правами изменения неразделенных данных и следующими правами:
//       Толстый клиент,
//       Внешнее соединение,
//       Automation,
//       Режим все функции,
//       Интерактивное открытие внешних обработок,
//       Интерактивное открытие внешних отчетов.
//     Такие роли в большей части существует в БСП, но могут встречаться и в прикладных решениях.
//
//   * ТолькоДляВнешнихПользователей - Массив - имена ролей, которые предназначены
//     только для внешних пользователей (роли со специально разработанным набором прав), например:
//       ДобавлениеИзменениеОтветовНаВопросыАнкет, БазовыеПраваВнешнегоПользователя.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
//   * СовместноДляПользователейИВнешнихПользователей - Массив - имена ролей, которые предназначены
//     для любых пользователей (и внутренних, и внешних, и неразделенных), например:
//       ЧтениеОтветовНаВопросыАнкет, ДобавлениеИзменениеЛичныхВариантовОтчетов.
//     Такие роли существуют и в БСП, и в прикладных решениях (если используются внешние пользователи).
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	//АСТБ_ALEXEY_**************************************************************
	
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(Метаданные.Роли.ИспользоватьРабочийСтолВнешнегоПользователя.Имя);
	
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(Метаданные.Роли.ЗапускТонкогоКлиента.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(Метаданные.Роли.ВыводНаПринтерФайлБуферОбмена.Имя);
	
	//АСТБ_ALEXEY_**************************************************************
	
КонецПроцедуры

// Переопределяет поведение формы пользователя и формы внешнего пользователя,
// группы внешних пользователей.
//
// Параметры:
//  Ссылка - СправочникСсылка.Пользователи,
//           СправочникСсылка.ВнешниеПользователи,
//           СправочникСсылка.ГруппыВнешнихПользователей - ссылка на пользователя,
//           внешнего пользователя или группу внешних пользователей при создании формы.
//
//  ДействияВФорме - Структура - со свойствами:
//         * Роли                   - Строка - "", "Просмотр",     "Редактирование".
//         * КонтактнаяИнформация   - Строка - "", "Просмотр",     "Редактирование".
//         * СвойстваПользователяИБ - Строка - "", "Просмотр",     "Редактирование".
//         * СвойстваЭлемента       - Строка - "", "Просмотр",     "Редактирование".
//           
//           Для групп внешних пользователей КонтактнаяИнформация и СвойстваПользователяИБ не существуют.
//
Процедура ИзменитьДействияВФорме(Знач Ссылка, Знач ДействияВФорме) Экспорт
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
// Вызывается из процедуры ЗаписатьПользователяИБ(), если пользователь был действительно изменен.
// Используется, если при записи пользователя ИБ требуется сделать синхронные действия,
// например, обновить запись в соответствующем регистре.
//
// Параметры:
//  СтарыеСвойства - Структура - см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ().
//  НовыеСвойства  - Структура - см. параметры возвращаемые функцией Пользователи.ЗаписатьПользователяИБ().
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
//  Вызывается из процедуры УдалитьПользователяИБ(), если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - Структура - см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ().
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
КонецПроцедуры

// Переопределяет настройки интерфейса, устанавливаемые для новых пользователей.
//
// Параметры:
//  НачальныеНастройки - Структура - настройки по умолчанию:
//   * НастройкиКлиента    - НастройкиКлиентскогоПриложения           - настройки клиентского приложения.
//   * НастройкиИнтерфейса - НастройкиКомандногоИнтерфейса            - настройки командного интерфейса (панели
//                                                                      разделов, панели навигации, панели действий).
//   * НастройкиТакси      - НастройкиИнтерфейсаКлиентскогоПриложения - настройки интерфейса клиентского приложения
//                                                                      (состав и размещение панелей).
//
//   * ЭтоВнешнийПользователь - Булево - если Истина, то это внешний пользователь.
//
Процедура ПриУстановкеНачальныхНастроек(НачальныеНастройки) Экспорт
	
	
	
КонецПроцедуры

// Дополняет список настроек переданного пользователя на вкладке "Прочее" обработки НастройкиПользователей.
//
// Параметры:
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка  - СправочникСсылка.Пользователи - пользователь,
//                               у которого нужно получить настройки.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             у которого нужно получить настройки.
//  Настройки - Структура - прочие пользовательские настройки.
//       * Ключ     - Строка - строковый идентификатор настройки, используемый в дальнейшем
//                             для копирования и очистки этой настройки.
//       * Значение - Структура - информация о настройке.
//              ** НазваниеНастройки  - Строка - название, которое будет отображаться в дереве настроек.
//              ** КартинкаНастройки  - Картинка - картинка, которая будет отображаться в дереве настроек.
//              ** СписокНастроек     - СписокЗначений - список полученных настроек.
//
Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Сохраняет настройки переданному пользователю.
//
// Параметры:
//  Настройки - Структура - структура с полями:
//       * ИдентификаторНастройки - Строка - строковый идентификатор копируемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений копируемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно скопировать настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно скопировать настройку.
//
Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

// Очищает настройки переданному пользователю.
//
// Параметры:
//  Настройки - Структура - структура с полями:
//       * ИдентификаторНастройки - Строка - строковый идентификатор очищаемой настройки.
//       * ЗначениеНастройки      - СписокЗначений - список значений очищаемых настроек.
//  СведенияОПользователе - Структура - строковое и ссылочное представление пользователя.
//       * ПользовательСсылка - СправочникСсылка.Пользователи - пользователь,
//                              которому нужно очистить настройку.
//       * ИмяПользователяИнформационнойБазы - Строка - пользователь информационной базы,
//                                             которому нужно очистить настройку.
//
Процедура ПриУдаленииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
