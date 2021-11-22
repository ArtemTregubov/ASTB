
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОбъектОтбора", ОбъектСсылка);
	
	ИсходныйОбъект = ОбъектСсылка;
	
	Если ЗначениеЗаполнено(ОбъектСсылка) Тогда
		ОбновитьДеревоСтруктурыПодчиненности();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ВывестиСтруктуруПодчиненности();
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиДляТекущего(Команда)
	
	ТекущийОбъект = Элементы.ТаблицаОтчета.ТекущаяОбласть.Расшифровка;
	
	Если ЗначениеЗаполнено(ТекущийОбъект) Тогда
		ОбъектСсылка = ТекущийОбъект;
	Иначе
		Возврат;
	КонецЕсли;
	
	ВывестиСтруктуруПодчиненности();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры вывода в табличный документ.

// Выводит дерево подчиненности в табличный документ.
&НаСервере
Процедура ВывестиТабличныйДокумент()

	ТаблицаОтчета.Очистить();
	
	Макет = ПолучитьОбщийМакет("СтруктураПодчиненности");
	
	ВывестиРодительскиеЭлементыДерева(ДеревоРодительскиеОбъекты.ПолучитьЭлементы(),Макет,1);
	ВывестиТекущийОбъект(Макет);
	ВывестиПодчиненныеЭлементыДерева(ДеревоПодчиненныеОбъекты.ПолучитьЭлементы(),Макет,1)
	
КонецПроцедуры

// Выводит строки дерева родительских объектов.
//
// Параметры:
//  СтрокиДерева  - ДанныеФормыКоллекцияЭлементовДерева - строки дерева
//                 которые выводятся в табличный документ.
//  Макет  - МакетТабличногоДокумента - макет, на основании которого
//           происходит вывод в табличный документ.
//  УровеньРекурсии - Число - уровень рекурсии процедуры.
//
&НаСервере
Процедура ВывестиРодительскиеЭлементыДерева(СтрокиДерева,Макет,УровеньРекурсии)
	
	Счетчик =  СтрокиДерева.Количество();
	Пока Счетчик >0 Цикл
		
		ТекущаяСтрокаДерева = СтрокиДерева.Получить(Счетчик -1);
		ПодчиненныеЭлементыСтрокиДерева = ТекущаяСтрокаДерева.ПолучитьЭлементы();
		ВывестиРодительскиеЭлементыДерева(ПодчиненныеЭлементыСтрокиДерева,Макет,УровеньРекурсии + 1);
		
		Для инд=1 По УровеньРекурсии Цикл
			
			Если инд = УровеньРекурсии Тогда
				
				Если СтрокиДерева.Индекс(ТекущаяСтрокаДерева) < (СтрокиДерева.Количество()-1) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхПравоНиз");
				Иначе	
					Область = Макет.ПолучитьОбласть("КоннекторПравоНиз");
				КонецЕсли;
				
			Иначе
				
				Если НеобходимостьВыводаВертикальногоКоннектора(УровеньРекурсии - инд + 1,ТекущаяСтрокаДерева,Ложь) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("Отступ");
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если инд = 1 Тогда
				ТаблицаОтчета.Вывести(Область);
			Иначе
				ТаблицаОтчета.Присоединить(Область);
			КонецЕсли;
			
		КонецЦикла;
		
		ВывестиПредставлениеИКартинку(ТекущаяСтрокаДерева,Макет,Ложь,Ложь);

		Счетчик = Счетчик - 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Выводит в табличный документ картинку, соответствующую статусу объекта и его представление.
//
&НаСервере
Процедура ВывестиПредставлениеИКартинку(СтрокаДерева,Макет, ЭтоТекущийОбъект = Ложь, ЭтоПодчиненный = Неопределено)
	
	МетаданныеОбъекта = СтрокаДерева.Ссылка.Метаданные();
	ЭтоДокумент       = ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта);
	
	// Вывод картинки
	Если СтрокаДерева.Проведен Тогда
		Если ЭтоТекущийОбъект Тогда
			Если ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Количество() И ДеревоРодительскиеОбъекты.ПолучитьЭлементы().Количество()  Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерхНиз");
			ИначеЕсли ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторНиз");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторВерх");
			КонецЕсли;
		ИначеЕсли ЭтоПодчиненный = Истина Тогда
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоНиз");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
			КонецЕсли;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведенКоннекторЛевоВерх");
			Иначе
				ОбластьКартинка = Макет.ПолучитьОбласть("ДокументПроведен");
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли СтрокаДерева.ПометкаУдаления Тогда
		Если ЭтоТекущийОбъект Тогда
			Если ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Количество() И ДеревоРодительскиеОбъекты.ПолучитьЭлементы().Количество()  Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдалениеКоннекторВерхНиз", "СправочникПВХПомеченНаУдалениеКоннекторВерхНиз");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			ИначеЕсли ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Количество() Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдалениеКоннекторНиз", "СправочникПВХПомеченНаУдалениеКоннекторНиз");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			Иначе
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдалениеКоннекторВерх", "СправочникПВХПомеченНаУдалениеКоннекторВерх");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			КонецЕсли;
		ИначеЕсли ЭтоПодчиненный = Истина Тогда
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдалениеКоннекторЛевоНиз", "СправочникПВХПомеченНаУдалениеКоннекторЛевоНиз");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			Иначе
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдаление", "СправочникПВХПомеченНаУдалениеКоннекторЛево");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			КонецЕсли;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдалениеКоннекторЛевоВерх", "СправочникПВХПомеченНаУдалениеКоннекторЛевоВерх");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			Иначе
				ИмяОбласти = ?( ЭтоДокумент, "ДокументПомеченНаУдаление", "СправочникПВХПомеченНаУдалениеКоннекторЛево");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ЭтоТекущийОбъект Тогда
			Если ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Количество() И ДеревоРодительскиеОбъекты.ПолучитьЭлементы().Количество()  Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписанКоннекторВерхНиз", "СправочникПВХКоннекторВерхНиз");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			ИначеЕсли ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Количество() Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписанКоннекторНиз", "СправочникПВХКоннекторНиз");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			Иначе
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписанКоннекторВерх", "СправочникПВХКоннекторВерх");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			КонецЕсли;
		ИначеЕсли ЭтоПодчиненный = Истина Тогда
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписанКоннекторЛевоНиз", "СправочникПВХКоннекторЛевоНиз");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			Иначе
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписан", "СправочникПВХКоннекторЛево");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			КонецЕсли;
		Иначе
			Если СтрокаДерева.ПолучитьЭлементы().Количество() Тогда
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписанКоннекторЛевоВерх", "СправочникПВХКоннекторЛевоВерх");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			Иначе
				ИмяОбласти = ?( ЭтоДокумент, "ДокументЗаписан", "СправочникПВХКоннекторЛево");
				ОбластьКартинка = Макет.ПолучитьОбласть(ИмяОбласти);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ЭтоТекущийОбъект Тогда
		ТаблицаОтчета.Вывести(ОбластьКартинка) 
	Иначе
		ТаблицаОтчета.Присоединить(ОбластьКартинка);
	КонецЕсли;
	
	// Вывод объекта
	ОбластьОбъект = Макет.ПолучитьОбласть(?(ЭтоТекущийОбъект,"ТекущийОбъект","Объект"));
	ОбластьОбъект.Параметры.ПредставлениеОбъекта = СтрокаДерева.Представление;
	ОбластьОбъект.Параметры.Объект = СтрокаДерева.Ссылка;
	ТаблицаОтчета.Присоединить(ОбластьОбъект);
	
КонецПроцедуры

// Определяет необходимость вывода вертикального коннектора в  табличный документ.
//
// Параметры:
//  УровеньВверх  - Число - на каком количестве уровней выше находится 
//                 родитель от которого будет рисоваться вертикальный коннектор.
//  СтрокаДерева  - ДанныеФормыЭлементДерева - исходная строка дерева значений
//                  от которой ведется отсчет.
// Возвращаемое значение:
//   Булево   - необходимость вывода в области вертикального коннектора.
//
&НаСервере
Функция НеобходимостьВыводаВертикальногоКоннектора(УровеньВверх,СтрокаДерева,ИщемСредиПодчиненных = Истина)
	
	ТекущаяСтрока = СтрокаДерева;
	
	Для инд=1 По УровеньВверх Цикл
		
		ТекущаяСтрока = ТекущаяСтрока.ПолучитьРодителя();
		Если инд = УровеньВверх Тогда
			ИскомыйРодитель = ТекущаяСтрока;
		ИначеЕсли инд = (УровеньВверх-1) Тогда
			ИскомаяСтрока = ТекущаяСтрока;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИскомыйРодитель = Неопределено Тогда
		Если ИщемСредиПодчиненных Тогда
			ПодчиненныеЭлементыРодителя =  ДеревоПодчиненныеОбъекты.ПолучитьЭлементы(); 
		Иначе
			ПодчиненныеЭлементыРодителя =  ДеревоРодительскиеОбъекты.ПолучитьЭлементы();
		КонецЕсли;
	Иначе
		ПодчиненныеЭлементыРодителя =  ИскомыйРодитель.ПолучитьЭлементы(); 
	КонецЕсли;
	
	Возврат ПодчиненныеЭлементыРодителя.Индекс(ИскомаяСтрока) < (ПодчиненныеЭлементыРодителя.Количество()-1);
	
КонецФункции

// Выводит в табличный документ строку с документом, для которого формируется структура подчиненности.
//
// Параметры:
//  Макет  - МакетТабличногоДокумента - макет, на основании которого формируется табличный документ.
&НаСервере
Процедура ВывестиТекущийОбъект(Макет)
	
	Выборка = ПолучитьВыборкуПоРеквизитамОбъекта(ОбъектСсылка);
	Если Выборка.Следующий() Тогда
		
		ПереопределяемоеПредставление = СтруктураПодчиненностиПереопределяемый.ПредставлениеОбъектаДляВыводаВОтчет(Выборка);
		
		Если ПереопределяемоеПредставление <> Неопределено Тогда
			СтруктураРеквизитов = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка.Владелец().Выгрузить()[0]);
			СтруктураРеквизитов.Представление = ПереопределяемоеПредставление;
			ВывестиПредставлениеИКартинку(СтруктураРеквизитов,Макет,Истина);
		Иначе
			СтруктураРеквизитов = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка.Владелец().Выгрузить()[0]);
			СтруктураРеквизитов.Представление = ПредставлениеОбъектаДляВыводаВОтчет(СтруктураРеквизитов);
			ВывестиПредставлениеИКартинку(СтруктураРеквизитов,Макет,Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует представление документа для вывода в табличный документ.
//
// Параметры:
//  Выборка  - ВыборкаИзРезультатаЗапроса или ДанныеФормыЭлементДерева - набор данных
//             на основании которого формируется представление.
//
// Возвращаемое значение:
//   Строка   - сформированное представление.
//
&НаСервере
Функция ПредставлениеОбъектаДляВыводаВОтчет(Выборка)
	
	ПредставлениеОбъекта = Выборка.Представление;
	МетаданныеОбъекта = Выборка.Ссылка.Метаданные();
	
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		Если (Выборка.СуммаДокумента <> 0) И (Выборка.СуммаДокумента <> NULL) Тогда
			ПредставлениеОбъекта = ПредставлениеОбъекта + " " + НСтр("ru='на сумму'") + " " + Выборка.СуммаДокумента + " " + Выборка.Валюта;
		КонецЕсли;
	Иначе
		ПредставлениеОбъекта = ПредставлениеОбъекта + " (" + МетаданныеОбъекта.ПредставлениеОбъекта + ")";
	КонецЕсли;
	
	Возврат ПредставлениеОбъекта;
	
КонецФункции

// Выводит строки дерева подчиненных документов.
//
// Параметры:
//  СтрокиДерева  - ДанныеФормыКоллекцияЭлементовДерева - строки дерева
//                 которые выводятся в табличный документ.
//  Макет  - МакетТабличногоДокумента - макет, на основании которого
//                 происходит вывод в табличный документ.
//  УровеньРекурсии - Число - уровень рекурсии процедуры.
//
&НаСервере
Процедура ВывестиПодчиненныеЭлементыДерева(СтрокиДерева,Макет,УровеньРекурсии)

	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		
		ЭтоТекущийОбъект = (СтрокаДерева.Ссылка = ОбъектСсылка);
		ЭтоИсходныйОбъект = (СтрокаДерева.Ссылка = ИсходныйОбъект);
		ПодчиненныеЭлементыДерева = СтрокаДерева.ПолучитьЭлементы();
		
		// Вывод коннекторов
		Для инд = 1 По УровеньРекурсии Цикл
			Если УровеньРекурсии > инд Тогда
				
				Если НеобходимостьВыводаВертикальногоКоннектора(УровеньРекурсии - инд + 1,СтрокаДерева) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("Отступ");
					
				КонецЕсли;
			Иначе 
				
				Если СтрокиДерева.Количество() > 1 И (СтрокиДерева.Индекс(СтрокаДерева)<> (СтрокиДерева.Количество()-1)) Тогда
					Область = Макет.ПолучитьОбласть("КоннекторВерхПравоНиз");
				Иначе
					Область = Макет.ПолучитьОбласть("КоннекторВерхПраво");
				КонецЕсли;
				
			КонецЕсли;	
			
			Область.Параметры.Документ = ?(ЭтоИсходныйОбъект,Неопределено,СтрокаДерева.Ссылка);
			
			Если инд = 1 Тогда
				ТаблицаОтчета.Вывести(Область);
			Иначе
				ТаблицаОтчета.Присоединить(Область);
			КонецЕсли;
			
		КонецЦикла;		
		
		ВывестиПредставлениеИКартинку(СтрокаДерева,Макет,Ложь,Истина);
		
		// Вывод подчиненных элементов дерева.
		ВывестиПодчиненныеЭлементыДерева(ПодчиненныеЭлементыДерева,Макет,УровеньРекурсии + 1);
		
	КонецЦикла;
	
КонецПроцедуры

// Инициирует вывод в табличный документ и отображает его по окончанию формирования.
&НаКлиенте
Процедура ВывестиСтруктуруПодчиненности()

	ОбновитьДеревоСтруктурыПодчиненности();

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры построения дерева подчиненности документов.

&НаСервере
Процедура ОбновитьДеревоСтруктурыПодчиненности()

	Если ОсновнойДокументДоступен() Тогда
		СформироватьДеревьяДокументов();
		ВывестиТабличныйДокумент();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Документ, для которого сформирован отчет о структуре подчиненности, стал недоступен.'"));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревьяДокументов()

	ДеревоРодительскиеОбъекты.ПолучитьЭлементы().Очистить();
	ДеревоПодчиненныеОбъекты.ПолучитьЭлементы().Очистить();

	ВывестиРодительскиеОбъекты(ОбъектСсылка,ДеревоРодительскиеОбъекты);
	ВывестиПодчиненныеОбъекты(ОбъектСсылка,ДеревоПодчиненныеОбъекты);

КонецПроцедуры

&НаСервере
Функция ОсновнойДокументДоступен()

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	1
	|ИЗ
	|	" + ОбъектСсылка.Метаданные().ПолноеИмя() + " КАК Таб
	|ГДЕ
	|	Таб.Ссылка = &ТекущийОбъект
	|");
	Запрос.УстановитьПараметр("ТекущийОбъект", ОбъектСсылка);
	Возврат Не Запрос.Выполнить().Пустой();

КонецФункции

// Получает выборку по реквизитам документа.
//
// Параметры:
//  ОбъектСсылка  - ДокументСсылка, СправочникСсылка, ПВХСсылка - ссылка на объект, значения реквизитов которого получаются запросом.
//
// Возвращаемое значение:
//   ВыборкаИзРезультатаЗапроса
//
&НаСервере
Функция ПолучитьВыборкуПоРеквизитамОбъекта(ОбъектСсылка)
	
	МетаданныеОбъекта = ОбъектСсылка.Метаданные();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ссылка,
	|	#Проведен,
	|	ПометкаУдаления,
	|	#Сумма ,
	|	#Валюта,
	|	#Представление
	|ИЗ
	|	" + МетаданныеОбъекта.ПолноеИмя() + "
	|ГДЕ
	|	Ссылка = &Ссылка
	|";
	
	Если ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) Тогда
		ИмяРеквизитаСумма    = ИмяРеквизитаДокумента(МетаданныеОбъекта.Имя, "СуммаДокумента");
		ИмяРеквизитаВалюта   = ИмяРеквизитаДокумента(МетаданныеОбъекта.Имя, "Валюта");
		ИмяРеквизитаПроведен = "Проведен";
	Иначе
		ИмяРеквизитаСумма    = Неопределено;
		ИмяРеквизитаВалюта   = Неопределено;
		ИмяРеквизитаПроведен = "Ложь";
	КонецЕсли;
	
	ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеОбъекта, "#Проведен", ИмяРеквизитаПроведен, "Проведен", Истина);
	ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеОбъекта, "#Сумма", ИмяРеквизитаСумма, "СуммаДокумента");
	ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеОбъекта, "#Валюта", ИмяРеквизитаВалюта, "Валюта");
	
	МассивДопРеквизитов = СтруктураПодчиненностиПереопределяемый.МассивРеквизитовОбъектаДляФормированияПредставления(МетаданныеОбъекта.Имя);
	
	ДополнитьТекстЗапросаПоРеквизитамОбъекта(ТекстЗапроса, МассивДопРеквизитов);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ОбъектСсылка);
	Возврат Запрос.Выполнить().Выбрать(); 
	
КонецФункции

&НаСервере
Процедура ВывестиРодительскиеОбъекты(ТекущийОбъект, ДеревоРодитель)

	СтрокиДерева = ДеревоРодитель.ПолучитьЭлементы();
	МетаданныеОбъекта = ТекущийОбъект.Метаданные();
	СписокРеквизитов    = Новый СписокЗначений;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		
		Если Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
			
			Для Каждого ТекущийТип Из Реквизит.Тип.Типы() Цикл
				
				МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
				
				Если МетаданныеРеквизита <> Неопределено
					И (Метаданные.Документы.Содержит(МетаданныеРеквизита)
					   Или Метаданные.Справочники.Содержит(МетаданныеРеквизита)
					   Или Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеРеквизита))
					И ПравоДоступа("Чтение", МетаданныеРеквизита) Тогда
					
					ЗначениеРеквизита = ТекущийОбъект[Реквизит.Имя];
					
					Если ЗначениеЗаполнено(ЗначениеРеквизита)
						И ТипЗнч(ЗначениеРеквизита) = ТекущийТип
						И ЗначениеРеквизита <> ТекущийОбъект
						И СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено Тогда
						
						ЯвляетсяДокументом  = ОбщегоНазначения.ЭтоДокумент(МетаданныеРеквизита);
						
						Если ЯвляетсяДокументом Тогда
							СписокРеквизитов.Добавить(ЗначениеРеквизита,Формат(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеРеквизита, "Дата"),"ДЛФ=DT"));
						Иначе
							СписокРеквизитов.Добавить(ЗначениеРеквизита, Дата(1,1,1));
						КонецЕсли;
						
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;

	Для Каждого ТЧ Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		СтрРеквизитов = "";

		СодержимоеТЧ = ТекущийОбъект[ТЧ.Имя].Выгрузить();

		Для Каждого Реквизит Из ТЧ.Реквизиты Цикл

			Если Метаданные.КритерииОтбора.СвязанныеДокументы.Состав.Содержит(Реквизит) Тогда
				
				Для Каждого ТекущийТип Из Реквизит.Тип.Типы() Цикл
					
					МетаданныеРеквизита = Метаданные.НайтиПоТипу(ТекущийТип);
					
					Если МетаданныеРеквизита<>Неопределено
						И (Метаданные.Документы.Содержит(МетаданныеРеквизита)
						   Или Метаданные.Справочники.Содержит(МетаданныеРеквизита)
						   Или Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеРеквизита))
						И ПравоДоступа("Чтение", МетаданныеРеквизита) Тогда
						
						СтрРеквизитов = СтрРеквизитов + ?(СтрРеквизитов = "", "", ", ") + Реквизит.Имя;
						Прервать;
						
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;

		СодержимоеТЧ.Свернуть(СтрРеквизитов);
		Для Каждого КолонкаТЧ Из СодержимоеТЧ.Колонки Цикл

			Для Каждого СтрокаТЧ Из СодержимоеТЧ Цикл

				ЗначениеРеквизита = СтрокаТЧ[КолонкаТЧ.Имя];

				МетаданныеЗначения = Метаданные.НайтиПоТипу(ТипЗнч(ЗначениеРеквизита));
				
				Если МетаданныеЗначения <> Неопределено Тогда

					Если ЗначениеЗаполнено(ЗначениеРеквизита)
						И (Метаданные.Документы.Содержит(МетаданныеРеквизита)
						   Или Метаданные.Справочники.Содержит(МетаданныеРеквизита)
						   Или Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеРеквизита))
						И ЗначениеРеквизита <> ТекущийОбъект
						И СписокРеквизитов.НайтиПоЗначению(ЗначениеРеквизита) = Неопределено
						И ПравоДоступа("Чтение", МетаданныеЗначения) Тогда
						
						ЯвляетсяДокументом  = ОбщегоНазначения.ЭтоДокумент(МетаданныеЗначения);
						
						Если ЯвляетсяДокументом Тогда
							СписокРеквизитов.Добавить(ЗначениеРеквизита,Формат(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеРеквизита, "Дата"),"ДЛФ=DT"));
						Иначе
							СписокРеквизитов.Добавить(ЗначениеРеквизита, Дата(1,1,1));
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

	СписокРеквизитов.СортироватьПоПредставлению();
	
	Для каждого ЭлементСписка Из СписокРеквизитов Цикл
		
		Выборка = ПолучитьВыборкуПоРеквизитамОбъекта(ЭлементСписка.Значение);
		
		Если Выборка.Следующий() Тогда
			СтрокаДерева = ДобавитьСтрокуВДерево(СтрокиДерева, Выборка);
			Если НЕ ДобавляемыйОбъектИмеетсяСредиРодителей(ДеревоРодитель,ЭлементСписка.Значение) Тогда
				ВывестиРодительскиеОбъекты(ЭлементСписка.Значение,СтрокаДерева);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет наличие документа среди родителей строки дерева, которая возможно будет добавлена.
//
// Параметры:
//  СтрокаРодитель  - ДанныеФормыДерево,ДанныеФормыЭлементДерева - родитель, для 
//                 которого предполагается добавить строку дерева.
//  ИскомыйОбъект  - Ссылка - ссылка на объект метаданных, на наличие которого выполняется проверка.
//
// Возвращаемое значение:
//   Булево   - Истина если найден, Ложь в обратном случае.
//
Функция ДобавляемыйОбъектИмеетсяСредиРодителей(СтрокаРодитель,ИскомыйОбъект)
	
	Если ИскомыйОбъект = ОбъектСсылка Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ТипЗнч(СтрокаРодитель) = Тип("ДанныеФормыДерево") Тогда
		Возврат Ложь; 
	КонецЕсли;
	
	ТекущийРодитель = СтрокаРодитель;
	Пока ТекущийРодитель <> Неопределено Цикл
		Если ТекущийРодитель.Ссылка = ИскомыйОбъект Тогда
		    Возврат Истина;
		КонецЕсли;
		ТекущийРодитель = ТекущийРодитель.ПолучитьРодителя();
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ЗаменитьТекстЗапроса(ТекстЗапроса, МетаданныеОбъекта, ЧтоЗаменять, ИмяРеквизита, Представление, НеИскатьВРеквизитах = Ложь)

	Если НеИскатьВРеквизитах Или МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ЧтоЗаменять, ИмяРеквизита + " КАК " + Представление);
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ЧтоЗаменять, " NULL КАК " + Представление);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДополнитьКэшМетаданных(МетаданныеОбъекта, ИмяОбъекта,КэшРеквизитовОбъекта)

	РеквизитыДокумента = КэшРеквизитовОбъекта[ИмяОбъекта];
	Если РеквизитыДокумента = Неопределено Тогда
		
		РеквизитыДокумента = Новый Соответствие;
		ЯвляетсяДокументом = ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта);
		
		ИмяРеквизитаСуммаДокумента = ИмяРеквизитаДокумента(МетаданныеОбъекта.Имя, "СуммаДокумента");
		Если ЯвляетсяДокументом И МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизитаСуммаДокумента) <> Неопределено Тогда
			РеквизитыДокумента.Вставить("СуммаДокумента", ИмяРеквизитаСуммаДокумента);
		Иначе
			РеквизитыДокумента.Вставить("СуммаДокумента", "NULL");
		КонецЕсли;
		
		ИмяРеквизитаВалюта = ИмяРеквизитаДокумента(МетаданныеОбъекта.Имя, "Валюта");
		Если ЯвляетсяДокументом И МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизитаВалюта) <> Неопределено Тогда
			РеквизитыДокумента.Вставить("Валюта", ИмяРеквизитаВалюта);
		Иначе
			РеквизитыДокумента.Вставить("Валюта", "NULL");
		КонецЕсли;
		
		Если ЯвляетсяДокументом Тогда
			РеквизитыДокумента.Вставить("Проведен", "Проведен");
		Иначе
			РеквизитыДокумента.Вставить("Проведен", "Ложь");
		КонецЕсли;
		
		Если ЯвляетсяДокументом Тогда
			РеквизитыДокумента.Вставить("Дата", "Дата");
		Иначе
			РеквизитыДокумента.Вставить("Дата", "NULL");
		КонецЕсли;

		КэшРеквизитовОбъекта.Вставить(ИмяОбъекта, РеквизитыДокумента);

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбъектыПоКритериюОтбора(ЗначениеКритерияОтбора)
	
	Если Метаданные.КритерииОтбора.СвязанныеДокументы.Тип.СодержитТип(ТипЗнч(ЗначениеКритерияОтбора))  Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	СвязанныеДокументы.Ссылка
		|ИЗ
		|	КритерийОтбора.СвязанныеДокументы(&ЗначениеКритерияОтбора) КАК СвязанныеДокументы";
		
		Запрос.УстановитьПараметр("ЗначениеКритерияОтбора",ЗначениеКритерияОтбора);
		Возврат Запрос.Выполнить().Выгрузить();
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ВывестиПодчиненныеОбъекты(ТекущийОбъект,ДеревоРодитель)
	
	СтрокиДерева = ДеревоРодитель.ПолучитьЭлементы();
	Таблица      = ОбъектыПоКритериюОтбора(ТекущийОбъект);
	Если Таблица = Неопределено Тогда
		Возврат;
	КонецЕсли;

	КэшПоТипамОбъектов   = Новый Соответствие;
	КэшРеквизитовОбъекта = Новый Соответствие;

	Для Каждого СтрокаТаблицы Из Таблица Цикл

		МетаданныеОбъекта = СтрокаТаблицы.Ссылка.Метаданные();
		Если Не ПравоДоступа("Чтение", МетаданныеОбъекта) Тогда
			Продолжить;
		КонецЕсли;

		ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
		ДополнитьКэшМетаданных(МетаданныеОбъекта, ПолноеИмяОбъекта, КэшРеквизитовОбъекта);

		МассивСсылок = КэшПоТипамОбъектов[ПолноеИмяОбъекта];
		Если МассивСсылок = Неопределено Тогда

			МассивСсылок = Новый Массив;
			КэшПоТипамОбъектов.Вставить(ПолноеИмяОбъекта, МассивСсылок);

		КонецЕсли;

		МассивСсылок.Добавить(СтрокаТаблицы.Ссылка);

	КонецЦикла;
	
	Если КэшПоТипамОбъектов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ТекстЗапросаНачало = "ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ (";
	ТекстЗапросаКонец = ") КАК ПодчиненныеОбъекты УПОРЯДОЧИТЬ ПО ПодчиненныеОбъекты.Дата";

	Запрос = Новый Запрос;
	ТекстЗапроса = "";
	Для Каждого КлючИЗначение Из КэшПоТипамОбъектов Цикл
		
		МассивИмениОбъекта = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КлючИЗначение.Ключ, ".");
		Если МассивИмениОбъекта.Количество() = 2 Тогда
			ИмяОбъекта = МассивИмениОбъекта[1];
		Иначе
			Продолжить;
		КонецЕсли;

		ТекстПоТипуОбъекта = "
		|" + КэшРеквизитовОбъекта[КлючИЗначение.Ключ]["Дата"] + "           КАК Дата,
		|	Ссылка,
		|" + КэшРеквизитовОбъекта[КлючИЗначение.Ключ]["Проведен"] + "       КАК Проведен,
		|	ПометкаУдаления,
		|" + КэшРеквизитовОбъекта[КлючИЗначение.Ключ]["СуммаДокумента"] + " КАК СуммаДокумента,
		|" + КэшРеквизитовОбъекта[КлючИЗначение.Ключ]["Валюта"] + "         КАК Валюта,
		|	#Представление
		|ИЗ
		|	" + КлючИЗначение.Ключ + "
		|ГДЕ
		|	Ссылка В (&" + ИмяОбъекта + ")";
		
		Запрос.УстановитьПараметр(ИмяОбъекта, КлючИЗначение.Значение);
		
		МассивДопРеквизитов = СтруктураПодчиненностиПереопределяемый.МассивРеквизитовОбъектаДляФормированияПредставления(ИмяОбъекта);
		ДополнитьТекстЗапросаПоРеквизитамОбъекта(ТекстПоТипуОбъекта, МассивДопРеквизитов);
		
		ТекстЗапроса = ТекстЗапроса + ?(ТекстЗапроса = "", " ВЫБРАТЬ ", " ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ") + ТекстПоТипуОбъекта;

	КонецЦикла;

	Запрос.Текст = ТекстЗапросаНачало + ТекстЗапроса + ТекстЗапросаКонец;
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ДобавитьСтрокуВДерево(СтрокиДерева, Выборка);
		Если НЕ ДобавляемыйОбъектИмеетсяСредиРодителей(ДеревоРодитель,Выборка.Ссылка) Тогда
			ВывестиПодчиненныеОбъекты(Выборка.Ссылка,НоваяСтрока)
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ДобавитьСтрокуВДерево(СтрокиДерева, Выборка)

	НоваяСтрока = СтрокиДерева.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, "Ссылка, Представление, СуммаДокумента, Валюта, Проведен, ПометкаУдаления");
	
	ПереопределенноеПредставление = СтруктураПодчиненностиПереопределяемый.ПредставлениеОбъектаДляВыводаВОтчет(Выборка);
	Если ПереопределенноеПредставление <> Неопределено Тогда
		НоваяСтрока.Представление = ПереопределенноеПредставление;
	Иначе
		НоваяСтрока.Представление = ПредставлениеОбъектаДляВыводаВОтчет(Выборка);
	КонецЕсли;
	
	Возврат НоваяСтрока;

КонецФункции

&НаСервере
Процедура ДополнитьТекстЗапросаПоРеквизитамОбъекта(ТекстЗапроса, МассивРеквизитов)
	
	ТекстПредставление = "Представление КАК Представление";
	
	Для Инд = 1 По 3 Цикл
		
		ТекстПредставление = ТекстПредставление + ",
			|	" + ?(МассивРеквизитов.Количество() >= Инд,МассивРеквизитов[инд - 1],"NULL") + " Как ДополнительныйРеквизит" + Инд;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#Представление", ТекстПредставление);
	
КонецПроцедуры

Функция ИмяРеквизитаДокумента(ИмяОбъекта, Реквизит) 
	
	ИмяРеквизитаДокумента = СтруктураПодчиненностиПереопределяемый.ИмяРеквизитаДокумента(ИмяОбъекта, Реквизит); 
	
	Если Реквизит = "СуммаДокумента" Тогда
		Возврат ?(ИмяРеквизитаДокумента = Неопределено,"СуммаДокумента",ИмяРеквизитаДокумента);
	ИначеЕсли Реквизит = "Валюта" Тогда
		Возврат ?(ИмяРеквизитаДокумента = Неопределено,"Валюта",ИмяРеквизитаДокумента);
	КонецЕсли;
	
КонецФункции

#КонецОбласти
