
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.ПрограммноеОткрытие Тогда
		ВызватьИсключение
			НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ПропуститьПерезапуск = Параметры.ПропуститьПерезапуск;
	
	МакетДокумента = Обработки.ЛегальностьПолученияОбновлений.ПолучитьМакет(
		"УсловияРаспространенияОбновлений");
	
	ТекстПредупреждения = МакетДокумента.ПолучитьТекст();
	ПодтверждениеВыбора = 0; // Пользователю требуется явно выбрать один из вариантов.
	Элементы.Примечание.Видимость = Параметры.ПоказыватьПредупреждениеОПерезапуске;
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	// СтандартныеПодсистемы.ЦентрМониторинга
	//
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Если ЦентрМониторингаСуществует Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		ПараметрыЦентраМониторинга = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов();
				
		Если (НЕ ПараметрыЦентраМониторинга.ВключитьЦентрМониторинга И  НЕ ПараметрыЦентраМониторинга.ЦентрОбработкиИнформацииОПрограмме) Тогда
			РазрешитьОтправкуСтатистики = Истина;
			Элементы.ГруппаОтправкаСтатистики.Видимость = Истина;
		Иначе
			РазрешитьОтправкуСтатистики = Истина;
			Элементы.ГруппаОтправкаСтатистики.Видимость = Ложь;	
		КонецЕсли;
	Иначе
		Элементы.ГруппаОтправкаСтатистики.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЦентрМониторинга
	//
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ИнформационнаяБазаФайловая
		И СтрНайти(ПараметрЗапуска, "ВыполнитьОбновлениеИЗавершитьРаботу") > 0 Тогда
		ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ПодтвердитьЛегальностьПолученияОбновления", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОсновныеДействияФормыПродолжить(Команда)
	
	Результат = ПодтверждениеВыбора = 1;
	
	Если Результат <> Истина Тогда
		Если Параметры.ПоказыватьПредупреждениеОПерезапуске И НЕ ПропуститьПерезапуск Тогда
			ПрекратитьРаботуСистемы();
		КонецЕсли;
	Иначе
		ЗаписатьПодтверждениеЛегальностиИОтправкиСтатистики(РазрешитьОтправкуСтатистики);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	ИначеЕсли Результат <> Истина Тогда
		Если Параметры.ПоказыватьПредупреждениеОПерезапуске И НЕ ПропуститьПерезапуск Тогда
			ПрекратитьРаботуСистемы();
		КонецЕсли;
	Иначе
		ЗаписатьПодтверждениеЛегальностиИОтправкиСтатистики(РазрешитьОтправкуСтатистики);
	КонецЕсли;
	
	Оповестить("ЛегальностьПолученияОбновлений", Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодтвердитьЛегальностьПолученияОбновления()
	ВыполнитьОбработкуОповещения(ЭтотОбъект.ОписаниеОповещенияОЗакрытии, Истина);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьПодтверждениеЛегальностиИОтправкиСтатистики(РазрешитьОтправкуСтатистики)
	
	ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЦентрМониторингаСуществует = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга");
	Если ЦентрМониторингаСуществует Тогда
		МодульЦентрМониторингаСлужебный = ОбщегоНазначения.ОбщийМодуль("ЦентрМониторингаСлужебный");
		
		ПараметрыОтправкиСтатистики = Новый Структура("ВключитьЦентрМониторинга, ЦентрОбработкиИнформацииОПрограмме", Неопределено, Неопределено);
		ПараметрыОтправкиСтатистики = МодульЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторингаВнешнийВызов(ПараметрыОтправкиСтатистики);
		
		Если (НЕ ПараметрыОтправкиСтатистики.ВключитьЦентрМониторинга И ПараметрыОтправкиСтатистики.ЦентрОбработкиИнформацииОПрограмме) Тогда
			// Настроена отправка статистики стороннему разработчику
			// настройки не меняем.
			//
		Иначе
			Если РазрешитьОтправкуСтатистики Тогда
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ВключитьЦентрМониторинга", РазрешитьОтправкуСтатистики);
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ЦентрОбработкиИнформацииОПрограмме", Ложь);
				РегЗадание = МодульЦентрМониторингаСлужебный.ПолучитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики", Истина);
				МодульЦентрМониторингаСлужебный.УстановитьРасписаниеПоУмолчаниюВнешнийВызов(РегЗадание);
			Иначе
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ВключитьЦентрМониторинга", РазрешитьОтправкуСтатистики);
				МодульЦентрМониторингаСлужебный.УстановитьПараметрЦентраМониторингаВнешнийВызов("ЦентрОбработкиИнформацииОПрограмме", Ложь);
				МодульЦентрМониторингаСлужебный.УдалитьРегламентноеЗаданиеВнешнийВызов("СборИОтправкаСтатистики");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьПодтверждениеЛегальностиПолученияОбновлений()
	УстановитьПривилегированныйРежим(Истина);
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьПодтверждениеЛегальностиПолученияОбновлений();
КонецПроцедуры

#КонецОбласти
