
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Респондент") Тогда
		Объект.Респондент = Параметры.Респондент;
	Иначе
	КонецЕсли;
	
	//АсТБ_Alexey_********************************************************************
	Если Параметры.Свойство("ВнешнийПользователь") Тогда
		Если Параметры.ВнешнийПользователь Тогда
			УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю();
		Иначе
			УстановитьПараметрыДинамическогоСпискаДереваАнкет();
		КонецЕсли;	
	Иначе
		УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю();
	КонецЕсли;
	//АсТБ_Alexey_********************************************************************
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтвеченныеАнкетыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ОтвеченныеАнкеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",ТекущиеДанные.Анкета);
	СтруктураПараметров.Вставить("ТолькоФормаЗаполнения",Истина);
	СтруктураПараметров.Вставить("ТолькоПросмотр",Истина);
	
	ОткрытьФорму("Документ.Анкета.Форма.ФормаДокумента",СтруктураПараметров,Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаДереваАнкет()
	
	Для каждого ДоступныйПараметр Из ОтвеченныеАнкеты.Параметры.ДоступныеПараметры.Элементы Цикл
		
		Если ДоступныйПараметр.Заголовок = "Респондент" Тогда
			ОтвеченныеАнкеты.Параметры.УстановитьЗначениеПараметра(ДоступныйПараметр.Параметр,Объект.Респондент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьРеспондентаСогласноТекущемуВнешнемуПользователю()
	
	Объект.Респондент = ВнешниеПользователи.ПолучитьОбъектАвторизацииВнешнегоПользователя();
	УстановитьПараметрыДинамическогоСпискаДереваАнкет();
	
КонецПроцедуры

#КонецОбласти
