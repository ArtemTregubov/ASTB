////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "ПЕЧАТЬ"

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
  УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
  
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Печать(Команда)
	
	ТекущиеДанные = Элементы.ФайлыСертификата.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	

	ПараметрыФормы = Новый Структура("ИмяФайла", ТекущиеДанные.ИмяФайла);
	ОткрытьФорму("Обработка.ПечатьСертификатов.Форма.Форма",ПараметрыФормы,ЭтаФорма,,,,,);
	
КонецПроцедуры
