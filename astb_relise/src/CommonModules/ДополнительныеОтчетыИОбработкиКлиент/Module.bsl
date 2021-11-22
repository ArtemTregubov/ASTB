////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму с доступными командами.
//
// Параметры:
//   ПараметрКоманды            - Передается "как есть" из параметров обработчика команды.
//   ПараметрыВыполненияКоманды - Передается "как есть" из параметров обработчика команды.
//   Вид - Строка - Вид обработки, который можно получить из серии функций:
//       ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработки<...>.
//   ИмяРаздела - Строка - Имя раздела командного интерфейса, из которого вызывается команда.
//
Процедура ОткрытьФормуКомандДополнительныхОтчетовИОбработок(ПараметрКоманды, ПараметрыВыполненияКоманды, Вид, ИмяРаздела = "") Экспорт
	
	ОбъектыНазначения = Новый СписокЗначений;
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда // назначаемая обработка
		ОбъектыНазначения.ЗагрузитьЗначения(ПараметрКоманды);
	КонецЕсли;
	
	Параметры = Новый Структура("ОбъектыНазначения, Вид, ИмяРаздела, РежимОткрытияОкна");
	Параметры.ОбъектыНазначения = ОбъектыНазначения;
	Параметры.Вид = Вид;
	Параметры.ИмяРаздела = ИмяРаздела;
	Параметры.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("УправляемаяФорма") Тогда // назначаемая обработка
		Параметры.Вставить("ИмяФормы", ПараметрыВыполненияКоманды.Источник.ИмяФормы);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыВыполненияКоманды) = Тип("ПараметрыВыполненияКоманды") Тогда
		ФормаСсылка = ПараметрыВыполненияКоманды.НавигационнаяСсылка;
	Иначе
		ФормаСсылка = Неопределено;
	КонецЕсли;
	
	ОткрытьФорму(
		"ОбщаяФорма.ДополнительныеОтчетыИОбработки", 
		Параметры,
		ПараметрыВыполненияКоманды.Источник,
		,
		,
		ФормаСсылка);
	
КонецПроцедуры

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета.
//   КлючВарианта - Строка - Имя варианта дополнительного отчета.
//
Процедура ОткрытьВариантДополнительногоОтчета(Ссылка, КлючВарианта) Экспорт
	
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОтчета = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(Ссылка);
	ПараметрыОткрытия = Новый Структура("КлючВарианта", КлючВарианта);
	Уникальность = "ВнешнийОтчет." + ИмяОтчета + "/КлючВарианта." + КлючВарианта;
	ОткрытьФорму("ВнешнийОтчет." + ИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Уникальность);
	
КонецПроцедуры

// Возвращает пустую структуру параметров выполнения команды в фоне.
//
//  Возвращаемое значение:
//    Структура - со свойствами:
//      * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Передается "как есть" из параметров формы.
//      * СопровождающийТекст - Строка - Текст длительной операции.
//      * ОбъектыНазначения - Массив - Ссылки объектов, для которых выполняется команда.
//          Используется для назначаемых дополнительных обработок.
//      * СозданныеОбъекты - Массив - Ссылки объектов, созданных в процессе выполнения команды.
//          Используется для назначаемых дополнительных обработок вида "Создание связанных объектов".
//      * ФормаВладелец - УправляемаяФорма - форма объекта или списка, из которой была вызвана команда.
//
Функция ПараметрыВыполненияКомандыВФоне(ДополнительнаяОбработкаСсылка) Экспорт
	
	Результат = Новый Структура("ДополнительнаяОбработкаСсылка", ДополнительнаяОбработкаСсылка);
	Результат.Вставить("СопровождающийТекст");
	Результат.Вставить("ОбъектыНазначения");
	Результат.Вставить("СозданныеОбъекты");
	Результат.Вставить("ФормаВладелец");
	Возврат Результат;
	
КонецФункции

// Выполняет команду ИдентификаторКоманды в фоне с помощью механизма длительных операций.
// Для использования в формах внешних отчетов и обработок.
//
// Параметры:
//   ИдентификаторКоманды - Строка - Имя команды как оно задано в функции СведенияОВнешнейОбработке модуля объекта.
//   ПараметрыКоманды - Структура - Параметры выполнения команды.
//       Состав параметров описан в функции ПараметрыВыполненияКомандыВФоне.
//       Также включает в себя служебный параметр, зарезервированный подсистемой:
//         * ИдентификаторКоманды - Строка - Имя выполняемой команды. Соответствует параметру ИдентификаторКоманды.
//       Помимо стандартных параметров может содержать пользовательские для использования в обработчике команды.
//       При добавлении собственных параметров рекомендуется использовать префикс в их именах,
//       исключающий конфликты со стандартными параметрами, например "Контекст...".
//   Обработчик - ОписаниеОповещения - Описание процедуры, которая принимает результат выполнения фонового задания.
//       Подробнее см. описание параметра ОповещениеОЗавершении процедуры ДлительныеОперацииКлиент.ОжидатьЗавершение().
//       Параметры процедуры:
//         * Задание - Структура, Неопределено - Сведения о фоновом задании.
//         * ДополнительныеПараметры - Значение, которое было указано при создании объекта ОписаниеОповещения.
//
// Пример:
//	&НаКлиенте
//	Процедура ОбработчикКоманды(Команда)
//		ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
//		ПараметрыКоманды.СопровождающийТекст = НСтр("ru = 'Выполняется команда...'");
//		Обработчик = Новый ОписаниеОповещения("<ИмяЭкспортнойПроцедуры>", ЭтотОбъект);
//		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(Команда.Имя, ПараметрыКоманды, Обработчик);
//	КонецПроцедуры
//
Процедура ВыполнитьКомандуВФоне(Знач ИдентификаторКоманды, Знач ПараметрыКоманды, Знач Обработчик) Экспорт
	
	ИмяПроцедуры = "ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ИдентификаторКоманды",
		ИдентификаторКоманды,
		Тип("Строка"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ПараметрыКоманды",
		ПараметрыКоманды,
		Тип("Структура"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ПараметрыКоманды.ДополнительнаяОбработкаСсылка",
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "ДополнительнаяОбработкаСсылка"),
		Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Обработчик",
		Обработчик,
		Новый ОписаниеТипов("ОписаниеОповещения, УправляемаяФорма"));
	
	ПараметрыКоманды.Вставить("ИдентификаторКоманды", ИдентификаторКоманды);
	ПолучатьРезультат = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "ПолучатьРезультат", Ложь);
	
	Форма = Неопределено;
	Если ПараметрыКоманды.Свойство("ФормаВладелец", Форма) Тогда
		ПараметрыКоманды.ФормаВладелец = Неопределено;
	КонецЕсли;
	Если ТипЗнч(Обработчик) = Тип("ОписаниеОповещения") Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Обработчик.Модуль",
			Обработчик.Модуль,
			Тип("УправляемаяФорма"));
		Форма = ?(Форма <> Неопределено, Форма, Обработчик.Модуль);
	Иначе
		Форма = Обработчик;
		Обработчик = Неопределено;
		ПолучатьРезультат = Истина;
	КонецЕсли;
	
	Задание = ДополнительныеОтчетыИОбработкиВызовСервера.ЗапуститьДлительнуюОперацию(Форма.УникальныйИдентификатор, ПараметрыКоманды);
	
	СопровождающийТекст = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "СопровождающийТекст", "");
	Заголовок = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыКоманды, "Заголовок");
	Если ЗначениеЗаполнено(Заголовок) Тогда
		СопровождающийТекст = СокрЛП(Заголовок + Символы.ПС + СопровождающийТекст);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(СопровождающийТекст) Тогда
		СопровождающийТекст = НСтр("ru = 'Команда выполняется.'");
	КонецЕсли;
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	НастройкиОжидания.ТекстСообщения       = СопровождающийТекст;
	НастройкиОжидания.ВыводитьОкноОжидания = Истина;
	НастройкиОжидания.ПолучатьРезультат    = ПолучатьРезультат;
	НастройкиОжидания.ВыводитьСообщения    = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Задание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

// Возвращает имя формы для идентификации результата выполнения длительной операции.
//
// Возвращаемое значение:
//   Строка - См. ВыполнитьКомандуВФоне.
//
Функция ИмяФормыДлительнойОперации() Экспорт
	
	Возврат "ОбщаяФорма.ДлительнаяОперация";
	
КонецФункции

// Выполняет назначаемую команду на клиенте, используя только неконтекстные серверные вызов.
//   Возвращает Ложь если для выполнения команды требуется серверный вызов.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, из которой вызвана команда.
//   ИмяЭлемента - Строка - Имя команды формы, которая была нажата.
//
// Возвращаемое значение:
//   Булево - Способ выполнения.
//       Истина - Команда обработки выполняется неконтекстно.
//       Ложь - Для выполнения требуется контекстный вызов сервера.
//
Функция ВыполнитьНазначаемуюКомандуНаКлиенте(Форма, ИмяЭлемента) Экспорт
	ОчиститьСообщения();
	
	ВыполняемаяКоманда = ДополнительныеОтчетыИОбработкиВызовСервера.ОписаниеКомандыОбработки(ИмяЭлемента, 
		Форма.Команды.Найти("АдресКомандДополнительныхОбработокВоВременномХранилище").Действие);
	
	Если ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ЗаполнениеФормы") Тогда
		Возврат Ложь; // Для выполнения команды требуется контекстный вызов сервера.
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",  Форма);
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ВыполняемаяКоманда", ВыполняемаяКоманда);
	
	Если Объект.Ссылка.Пустая() Или Форма.Модифицированность Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для выполнения команды ""%1"" необходимо записать данные.'"),
			ВыполняемаяКоманда.Представление);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать и продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Обработчик = Новый ОписаниеОповещения("ВыполнитьНазначаемуюКомандуНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, 60, КодВозвратаДиалога.Да);
	Иначе
		ВыполнитьНазначаемуюКомандуНаКлиентеЗавершение(-1, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат Истина; // Для выполнения команды достаточно клиентского контекста.
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Отображает результат выполнения команды.
//
Процедура ПоказатьРезультатВыполненияКоманды(Форма, РезультатВыполнения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов.

// Открывает форму подбора дополнительных отчетов.
// Места использования:
//   Справочник.РассылкиОтчетов.Форма.ФормаЭлемента.ДобавитьДополнительныйОтчет.
//
// Параметры:
//   ЭлементФормы - Произвольный - Элемент формы, в который выполняется подбор элементов.
//
Процедура РассылкаОтчетовПодборДопОтчета(ЭлементФормы) Экспорт
	
	ДополнительныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет");
	Отчет               = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет");
	
	ОтборПоВиду = Новый СписокЗначений;
	ОтборПоВиду.Добавить(ДополнительныйОтчет, ДополнительныйОтчет);
	ОтборПоВиду.Добавить(Отчет, Отчет);
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.Независимый);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("Вид", ОтборПоВиду));
	
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаВыбора", ПараметрыФормыВыбора, ЭлементФормы);
	
КонецПроцедуры

// Обработчик внешней команды печати.
//
// Параметры:
//  ПараметрыКоманды - Структура        - структура из строки таблицы команд, см.
//                                        ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати.
//  Форма            - УправляемаяФорма - форма, в которой выполняется команда печати.
//
Функция ВыполнитьНазначаемуюКомандуПечати(ВыполняемаяКоманда, Форма) Экспорт
	
	// Перенос дополнительных параметров, переданных этой подсистемой, в корень структуры.
	Для Каждого КлючИЗначение Из ВыполняемаяКоманда.ДополнительныеПараметры Цикл
		ВыполняемаяКоманда.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	// Запись фиксированных параметров.
	ВыполняемаяКоманда.Вставить("ЭтоОтчет", Ложь);
	ВыполняемаяКоманда.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма"));
	
	// Запуск метода обработки, соответствующего контексту команды.
	ВариантЗапуска = ВыполняемаяКоманда.ВариантЗапуска;
	Если ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	ИначеЕсли ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	Иначе
		ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выводит оповещение перед запуском команды.
Процедура ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда)
	Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Команда выполняется...'"), , ВыполняемаяКоманда.Представление);
	КонецЕсли;
КонецПроцедуры

// Открывает форму обработки.
Процедура ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы, КлючСессии");
	ПараметрыОбработки.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыОбработки.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыОбработки.ИмяФормы                      = ?(Форма = Неопределено, Неопределено, Форма.ИмяФормы);
	ПараметрыОбработки.КлючСессии = ВыполняемаяКоманда.Ссылка.УникальныйИдентификатор();
	
	Если ТипЗнч(ОбъектыНазначения) = Тип("Массив") Тогда
		ПараметрыОбработки.Вставить("ОбъектыНазначения", ОбъектыНазначения);
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВнешняяОбработка = ДополнительныеОтчетыИОбработкиВызовСервера.ОбъектВнешнейОбработки(ВыполняемаяКоманда.Ссылка);
		ФормаОбработки = ВнешняяОбработка.ПолучитьФорму(, Форма);
		Если ФормаОбработки = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для отчета или обработки ""%1"" не назначена основная форма,
				|или основная форма не предназначена для запуска в обычном приложении.
				|Команда ""%2"" не может быть выполнена.'"),
				Строка(ВыполняемаяКоманда.Ссылка),
				ВыполняемаяКоманда.Представление);
		КонецЕсли;
		ФормаОбработки.Открыть();
		ФормаОбработки = Неопределено;
	#Иначе
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ОткрытьФорму("ВнешнийОтчет." + ИмяОбработки + ".Форма", ПараметрыОбработки, Форма);
		Иначе
			ОткрытьФорму("ВнешняяОбработка." + ИмяОбработки + ".Форма", ПараметрыОбработки, Форма);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

// Выполняет клиентский метод обработки.
Процедура ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	
	ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда);
	
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы");
	ПараметрыОбработки.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыОбработки.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыОбработки.ИмяФормы                      = ?(Форма = Неопределено, Неопределено, Форма.ИмяФормы);;
	
	Если ТипЗнч(ОбъектыНазначения) = Тип("Массив") Тогда
		ПараметрыОбработки.Вставить("ОбъектыНазначения", ОбъектыНазначения);
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВнешняяОбработка = ДополнительныеОтчетыИОбработкиВызовСервера.ОбъектВнешнейОбработки(ВыполняемаяКоманда.Ссылка);
		ФормаОбработки = ВнешняяОбработка.ПолучитьФорму(, Форма);
		Если ФормаОбработки = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для отчета или обработки ""%1"" не назначена основная форма,
				|или основная форма не предназначена для запуска в обычном приложении.
				|Команда ""%2"" не может быть выполнена.'"),
				Строка(ВыполняемаяКоманда.Ссылка),
				ВыполняемаяКоманда.Представление);
		КонецЕсли;
	#Иначе
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ФормаОбработки = ПолучитьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма", ПараметрыОбработки, Форма);
		Иначе
			ФормаОбработки = ПолучитьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма", ПараметрыОбработки, Форма);
		КонецЕсли;
	#КонецЕсли
	
	Если ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка")
		Или ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор);
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов") Тогда
		
		СозданныеОбъекты = Новый Массив;
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения, СозданныеОбъекты);
		
		ТипыСозданныхОбъектов = Новый Массив;
		
		Для Каждого СозданныйОбъект Из СозданныеОбъекты Цикл
			Тип = ТипЗнч(СозданныйОбъект);
			Если ТипыСозданныхОбъектов.Найти(Тип) = Неопределено Тогда
				ТипыСозданныхОбъектов.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Тип Из ТипыСозданныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла;
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма") Тогда
		
		ФормаОбработки.Печать(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
		ТипыИзмененныхОбъектов = Новый Массив;
		
		Для Каждого ИзмененныйОбъект Из ОбъектыНазначения Цикл
			Тип = ТипЗнч(ИзмененныйОбъект);
			Если ТипыИзмененныхОбъектов.Найти(Тип) = Неопределено Тогда
				ТипыИзмененныхОбъектов.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Тип Из ТипыИзмененныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла;
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
	КонецЕсли;
	
	ФормаОбработки = Неопределено;
	
КонецПроцедуры

// Формирует табличный документ в форме подсистемы "Печать".
Процедура ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	
	СтандартнаяОбработка = Истина;
	ДополнительныеОтчетыИОбработкиКлиентПереопределяемый.ПередВыполнениемКомандыПечатиВнешнейПечатнойФормы(ОбъектыНазначения, СтандартнаяОбработка);
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВыполняемаяКоманда", ВыполняемаяКоманда);
	Параметры.Вставить("Форма", Форма);
	Если СтандартнаяОбработка Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОткрытиеПечатнойФормыЗавершение", ЭтотОбъект, Параметры);
		УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов(ОписаниеОповещения, ОбъектыНазначения, Форма);
	Иначе
		ВыполнитьОткрытиеПечатнойФормыЗавершение(ОбъектыНазначения, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ВыполнитьОткрытиеПечатнойФормы.
Процедура ВыполнитьОткрытиеПечатнойФормыЗавершение(ОбъектыНазначения, ДополнительныеПараметры) Экспорт
	
	ВыполняемаяКоманда = ДополнительныеПараметры.ВыполняемаяКоманда;
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ИдентификаторКоманды", ВыполняемаяКоманда.Идентификатор);
	ПараметрыИсточника.Вставить("ОбъектыНазначения",    ОбъектыНазначения);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИсточникДанных",     ВыполняемаяКоманда.Ссылка);
	ПараметрыОткрытия.Вставить("ПараметрыИсточника", ПараметрыИсточника);
	ПараметрыОткрытия.Вставить("ПараметрКоманды", ОбъектыНазначения);
	
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, Форма);
	
КонецПроцедуры

// Обработчик продолжения выполнения назначаемой команды на клиенте.
Процедура ВыполнитьНазначаемуюКомандуНаКлиентеЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Форма = ДополнительныеПараметры.Форма;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Если Не Форма.Записать() Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Ответ <> -1 Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняемаяКоманда = ДополнительныеПараметры.ВыполняемаяКоманда;
	Объект = ДополнительныеПараметры.Объект;
	
	ПараметрыВызоваСервера = Новый Структура;
	ПараметрыВызоваСервера.Вставить("ИдентификаторКоманды",          ВыполняемаяКоманда.Идентификатор);
	ПараметрыВызоваСервера.Вставить("ДополнительнаяОбработкаСсылка", ВыполняемаяКоманда.Ссылка);
	ПараметрыВызоваСервера.Вставить("ОбъектыНазначения",             Новый Массив);
	ПараметрыВызоваСервера.Вставить("ИмяФормы",                      Форма.ИмяФормы);
	ПараметрыВызоваСервера.ОбъектыНазначения.Добавить(Объект.Ссылка);
	
	ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда);
	
	// Контроль за результатом выполнения поддерживается только для серверных методов.
	// Если открывается форма или вызывается клиентский метод, то вывод результата выполнения выполняется обработкой.
	Если ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ИмяВнешнегоОбъекта = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ОткрытьФорму("ВнешнийОтчет."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		Иначе
			ОткрытьФорму("ВнешняяОбработка."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		КонецЕсли;
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ИмяВнешнегоОбъекта = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ФормаВнешнегоОбъекта = ПолучитьФорму("ВнешнийОтчет."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		Иначе
			ФормаВнешнегоОбъекта = ПолучитьФорму("ВнешняяОбработка."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		КонецЕсли;
		ФормаВнешнегоОбъекта.ВыполнитьКоманду(ПараметрыВызоваСервера.ИдентификаторКоманды, ПараметрыВызоваСервера.ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		ПараметрыВызоваСервера.Вставить("РезультатВыполнения", Новый Структура);
		ДополнительныеОтчетыИОбработкиВызовСервера.ВыполнитьКоманду(ПараметрыВызоваСервера, Неопределено);
		Форма.Прочитать();
		
	КонецЕсли;
КонецПроцедуры

// Показывает диалог установки расширения, затем выгружает данные дополнительного отчета или обработки.
Процедура ВыгрузитьВФайл(ПараметрыВыгрузки) Экспорт
	ТекстСообщения = НСтр("ru = 'Для выгрузки внешней обработки (отчета) в файл рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьВФайлЗавершение", ЭтотОбъект, ПараметрыВыгрузки);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов.

// Обработчик результата работы процедуры ВыгрузитьВФайл.
Процедура ВыгрузитьВФайлЗавершение(Подключено, ПараметрыВыгрузки) Экспорт
	Перем Адрес;
	
	ПараметрыВыгрузки.Свойство("АдресДанныхОбработки", Адрес);
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Адрес = ДополнительныеОтчетыИОбработкиВызовСервера.ПоместитьВХранилище(ПараметрыВыгрузки.Ссылка, Неопределено);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыВыгрузки", ПараметрыВыгрузки);
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	
	Если Не Подключено Тогда
		ПолучитьФайл(Адрес, ПараметрыВыгрузки.ИмяФайла, Истина);
		Возврат;
	КонецЕсли;
	
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохраненияФайла.ПолноеИмяФайла = ПараметрыВыгрузки.ИмяФайла;
	ДиалогСохраненияФайла.Фильтр = ДополнительныеОтчетыИОбработкиКлиентСервер.ФильтрДиалоговВыбораИСохранения();
	ДиалогСохраненияФайла.ИндексФильтра = ?(ПараметрыВыгрузки.ЭтоОтчет, 1, 2);
	ДиалогСохраненияФайла.МножественныйВыбор = Ложь;
	ДиалогСохраненияФайла.Заголовок = НСтр("ru = 'Укажите файл'");
	
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьФайлВыборФайла", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогСохраненияФайла.Показать(Обработчик);
	
КонецПроцедуры

// Обработчик результата работы процедуры ВыгрузитьВФайл.
Процедура ВыгрузитьФайлВыборФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПолноеИмяФайла = ВыбранныеФайлы[0];
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайла, ДополнительныеПараметры.Адрес));
		
		Обработчик = Новый ОписаниеОповещения("ОбработкаРезультатаНеТребуется", ЭтотОбъект);
		НачатьПолучениеФайлов(Обработчик, ПолучаемыеФайлы, ПолноеИмяФайла, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик результата работы процедуры ВыгрузитьВФайл.
Процедура ОбработкаРезультатаНеТребуется(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	// Обработка результата не требуется.
КонецПроцедуры

#КонецОбласти
