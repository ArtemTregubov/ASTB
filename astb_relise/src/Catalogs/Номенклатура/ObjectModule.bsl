#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтотОбъект.ЭтоГруппа И ЭтотОбъект.Комплект И ЭтотОбъект.Комплектующие.Количество() = 0 Тогда
		
		КлючДанных = ПроцедурыРаботыСНормамиСервер.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
		
		ТекстСообщения = НСтр("ru='Не заполнена таблица комплектующих'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,"Комплектующие","Объект",Отказ);
		
	КонецЕсли;
	
	//проверка пола комплекта (51781)
	Если НЕ ЭтотОбъект.ЭтоГруппа Тогда
		
		Если ЭтотОбъект.Комплект Тогда
			
			Если НЕ ЭтотОбъект.Комплектующие.Количество() = 0 И ЗначениеЗаполнено(ЭтотОбъект.Пол) Тогда
				
				ПолНеСовпадает = Истина;
				
				Для Каждого СтрокаКомплектующих Из ЭтотОбъект.Комплектующие Цикл
					
					Если СтрокаКомплектующих.Номенклатура.Пол = Перечисления.ПолФизическогоЛица.ПустаяСсылка() Тогда
						ПолНеСовпадает = Ложь;
						Прервать;
					КонецЕсли;	
					
					Если НЕ СтрокаКомплектующих.Номенклатура.Пол = ЭтотОбъект.Пол Тогда
						ПолНеСовпадает = Истина;
						Прервать;
					Иначе
						ПолНеСовпадает = Ложь;
					КонецЕсли;
					
				КонецЦикла;	
				
				Если ПолНеСовпадает Тогда
					
					ТекстСообщения = НСтр("ru='Пол комплекта не совпадает с полом комплектующих'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,"Пол","Объект",Отказ);
					
				КонецЕсли;	
				
			КонецЕсли;
			
		Иначе
			
			Если ЗначениеЗаполнено(ЭтотОбъект.Пол) И ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	НоменклатураКомплектующие.Ссылка КАК Комплект,
				|	НоменклатураКомплектующие.Номенклатура КАК Номенклатура,
				|	НоменклатураКомплектующие.Номенклатура.Пол КАК НоменклатураПол
				|ПОМЕСТИТЬ ВТ_Комплекты
				|ИЗ
				|	Справочник.Номенклатура.Комплектующие КАК НоменклатураКомплектующие
				|ГДЕ
				|	НЕ НоменклатураКомплектующие.Ссылка.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_Комплекты.Комплект КАК Комплект,
				|	МИНИМУМ(ВТ_Комплекты.НоменклатураПол) КАК НоменклатураПол
				|ПОМЕСТИТЬ ВТ_ПолКомплектующих
				|ИЗ
				|	ВТ_Комплекты КАК ВТ_Комплекты
				|
				|СГРУППИРОВАТЬ ПО
				|	ВТ_Комплекты.Комплект
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ВТ_ПолКомплектующих.Комплект КАК Комплект
				|ПОМЕСТИТЬ ВТ_КомплектыСПолом
				|ИЗ
				|	ВТ_ПолКомплектующих КАК ВТ_ПолКомплектующих
				|ГДЕ
				|	НЕ ВТ_ПолКомплектующих.НоменклатураПол = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.ПустаяСсылка)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ВТ_Комплекты.Комплект КАК Комплект
				|ИЗ
				|	ВТ_Комплекты КАК ВТ_Комплекты
				|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КомплектыСПолом КАК ВТ_КомплектыСПолом
				|		ПО (ВТ_Комплекты.Комплект = ВТ_КомплектыСПолом.Комплект)
				|ГДЕ
				|	ВТ_Комплекты.Номенклатура = &Номенклатура
				|	И НЕ ВТ_Комплекты.Комплект.Пол = &Пол
				|	И НЕ ВТ_КомплектыСПолом.Комплект ЕСТЬ NULL";
				
				Запрос.УстановитьПараметр("Номенклатура",	ЭтотОбъект.Ссылка);
				Запрос.УстановитьПараметр("Пол",			ЭтотОбъект.Пол);
				
				ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
				
				ТекстСообщения = "";
				
				Для Каждого СтрокаТаблицыЗапроса Из ТаблицаЗапроса Цикл
					
					ТекстСообщения = ТекстСообщения + "Пол комплектующего не совпадает с полом комплекта: (" + СтрокаТаблицыЗапроса.Комплект.Код + ") " + СтрокаТаблицыЗапроса.Комплект.Наименование + Символы.ПС;
					
				КонецЦикла;	
				
				Если НЕ ТекстСообщения = "" Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных,"Пол","Объект",Отказ);
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных.
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Наименование = &Наименование
	|	И Номенклатура.КодСинхронизации = &КодСинхронизации
	|	И НЕ Номенклатура.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Наименование", 		Наименование);
	Запрос.УстановитьПараметр("КодСинхронизации", 	КодСинхронизации);
	Запрос.УстановитьПараметр("Ссылка", 			Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = "Номенклатура с такими наименованием и кодом синхронизации уже существует.";
		СообщениеПользователю.Сообщить();
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

#КонецЕсли