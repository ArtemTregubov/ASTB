
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытиеФормыЗаписиГрафика");
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОбслуживанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	Если Направление = 1 Тогда
		Запись.ВремяОбслуживания = Запись.ВремяОбслуживания + 5;
	Иначе
		Запись.ВремяОбслуживания = Запись.ВремяОбслуживания - 5;
	КонецЕсли;		
	
	Запись.ВремяОбслуживания = Цел(Запись.ВремяОбслуживания / 5) * 5;
	
	МинимальноеОкончаниеРаботы = Запись.НачалоРаботы + Запись.ВремяОбслуживания * 60;
	Если МинимальноеОкончаниеРаботы > Запись.ОкончаниеРаботы Тогда
		Запись.ОкончаниеРаботы = МинимальноеОкончаниеРаботы;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоРаботыПриИзменении(Элемент)
	
	МинимальноеОкончаниеРаботы = Запись.НачалоРаботы + Запись.ВремяОбслуживания * 60;
	Если МинимальноеОкончаниеРаботы > Запись.ОкончаниеРаботы Тогда
		Запись.ОкончаниеРаботы = МинимальноеОкончаниеРаботы;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеРаботыПриИзменении(Элемент)
	
	МаксимальноеНачалоРаботы = Запись.ОкончаниеРаботы - Запись.ВремяОбслуживания * 60;
	Если МаксимальноеНачалоРаботы < Запись.НачалоРаботы Тогда
		Запись.НачалоРаботы = МаксимальноеНачалоРаботы;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПерерываПриИзменении(Элемент)
	
	МинимальноеОкончаниеПерерыва = Запись.НачалоПерерыва + 900;
	Если МинимальноеОкончаниеПерерыва > Запись.ОкончаниеПерерыва Тогда
		Запись.ОкончаниеПерерыва = МинимальноеОкончаниеПерерыва;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Запись.НачалоПерерыва) Тогда
		Запись.ОкончаниеПерерыва = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПерерываПриИзменении(Элемент)
	
	МаксимальноеНачалоПерерыва = Запись.ОкончаниеПерерыва - 900;
	Если МаксимальноеНачалоПерерыва < Запись.НачалоПерерыва Тогда
		Запись.НачалоПерерыва = МаксимальноеНачалоПерерыва;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Запись.ОкончаниеПерерыва) Тогда
		Запись.НачалоПерерыва = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Отказ = НЕ МожноМенять();
	
КонецПроцедуры

Функция МожноМенять()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаписиНаСкладСрезПоследних.Организация КАК Организация,
	|	ЗаписиНаСкладСрезПоследних.Склад КАК Склад,
	|	ЗаписиНаСкладСрезПоследних.День КАК День,
	|	ЗаписиНаСкладСрезПоследних.Сотрудник КАК Сотрудник,
	|	ЗаписиНаСкладСрезПоследних.Время КАК Время
	|ПОМЕСТИТЬ ВТ_ЗаписиНаСклад
	|ИЗ
	|	РегистрСведений.ЗаписиНаСклад.СрезПоследних(
	|			,
	|			Склад = &Склад
	|				И День = &День) КАК ЗаписиНаСкладСрезПоследних
	|ГДЕ
	|	ЗаписиНаСкладСрезПоследних.Использовать
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ЗаписиНаСклад.Организация КАК Организация,
	|	ВТ_ЗаписиНаСклад.Склад КАК Склад,
	|	ВТ_ЗаписиНаСклад.День КАК День,
	|	ВТ_ЗаписиНаСклад.Время КАК Время,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ЗаписиНаСклад.Сотрудник) КАК КоличествоСотрудников
	|ПОМЕСТИТЬ ВТ_КоличествоЗаписей
	|ИЗ
	|	ВТ_ЗаписиНаСклад КАК ВТ_ЗаписиНаСклад
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ЗаписиНаСклад.Организация,
	|	ВТ_ЗаписиНаСклад.Склад,
	|	ВТ_ЗаписиНаСклад.День,
	|	ВТ_ЗаписиНаСклад.Время
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВТ_КоличествоЗаписей.КоличествоСотрудников) КАК МаксимальноеКоличествоЗаписей,
	|	ВТ_КоличествоЗаписей.Склад КАК Склад,
	|	ВТ_КоличествоЗаписей.День КАК День
	|ИЗ
	|	ВТ_КоличествоЗаписей КАК ВТ_КоличествоЗаписей
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_КоличествоЗаписей.Склад,
	|	ВТ_КоличествоЗаписей.День";
	
	Запрос.УстановитьПараметр("Склад",	Запись.Склад);
	Запрос.УстановитьПараметр("День",	Запись.День);
	
	РезультатЗапросаПоЗаписям = Запрос.Выполнить();
	
	Если РезультатЗапросаПоЗаписям.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	//получаем старые условия времени
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ГрафикРаботыСклада.ВремяОбслуживания КАК ВремяОбслуживания,
	|	ГрафикРаботыСклада.НачалоРаботы КАК НачалоРаботы,
	|	ГрафикРаботыСклада.ОкончаниеРаботы КАК ОкончаниеРаботы
	|ИЗ
	|	РегистрСведений.ГрафикРаботыСклада КАК ГрафикРаботыСклада
	|ГДЕ
	|	ГрафикРаботыСклада.Склад = &Склад
	|	И ГрафикРаботыСклада.День = &День";
	
	Запрос.УстановитьПараметр("Склад",	Запись.Склад);
	Запрос.УстановитьПараметр("День",	Запись.День);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТаблицаЗапроса = Результат.Выгрузить();
	
	Если НЕ ТаблицаЗапроса[0].ВремяОбслуживания = Запись.ВремяОбслуживания Тогда
		
		Если НЕ РезультатЗапросаПоЗаписям.Пустой() Тогда//время обслуживания менять нельзя
			
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "На данный день уже существуют записи. Уменьшать время обслуживания запрещено!";
			СообщениеПользователю.Сообщить();
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Запись.НачалоПерерыва) Тогда
		
		Если Запись.НачалоПерерыва < Запись.НачалоРаботы Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Неверно задано время перерыва.";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
		КонецЕсли;			
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ОкончаниеПерерыва) Тогда
		
		Если Запись.ОкончаниеПерерыва > Запись.ОкончаниеРаботы Тогда
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Неверно задано время перерыва.";
			СообщениеПользователю.Сообщить();
			Отказ = Истина;
		КонецЕсли;			
		
	КонецЕсли;
	
КонецПроцедуры

