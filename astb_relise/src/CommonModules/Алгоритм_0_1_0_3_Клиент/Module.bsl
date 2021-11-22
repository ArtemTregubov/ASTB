#Область ИнтерфейсДокументаВыдачиСИЗ

Процедура ВыдачаСИЗ_ТоварыНеВыданоПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	ТекущиеДанные = ФормаДокумента.Элементы.Товары.ТекущиеДанные;
	
	СтруктураТекущихДанных = ПроцедурыРаботыСНормамиКлиент.ПеренестиТекущиеДанныеВыдачиВСтруктуру(ТекущиеДанные);
	
	Если ТекущиеДанные.НеВыдано Тогда
		ТекущиеДанные.Номенклатура 					= ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
		ТекущиеДанные.ХарактеристикаНоменклатуры 	= ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
		ТекущиеДанные.Цена 							= 0;
		ТекущиеДанные.Сумма 						= 0;
		ТекущиеДанные.Количество					= 0;
		ТекущиеДанные.КоличествоВКомплекте			= 0;
		ТекущиеДанные.ВыдачаСверхНорм				= Ложь;
	Иначе
		ТекущиеДанные.НеВыданоПоПричине = ПредопределенноеЗначение("Справочник.ПричиныНевыдачиСИЗ.ПустаяСсылка");
		ТекущиеДанные.Количество = ТекущиеДанные.КоличествоПотребность;
		//Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		//	ТекущиеДанные.Цена 	= ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(ТекущиеДанные.Номенклатура,ТекущийОбъект.Организация,ТекущийОбъект.Дата);
		//	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
		//КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		ТекущиеДанные.Цена 	= ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(ТекущиеДанные.Номенклатура,ТекущийОбъект.Организация,ТекущийОбъект.Дата);
		ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ТекущиеДанные.Комплект) Тогда
		ФормаДокумента.СкорректироватьКомплекты(СтруктураТекущихДанных);
	КонецЕсли;
		
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");	
	
КонецПроцедуры

//АсТБ_Alexey_102437_********************************************************************

Процедура ВыдачаСИЗ_ОбработатьСтрокуПоНевыдано(СтрокаТаблицы,ТекущийОбъект,ФормаДокумента) Экспорт
	
	СтруктураТекущихДанных = ПроцедурыРаботыСНормамиКлиент.ПеренестиТекущиеДанныеВыдачиВСтруктуру(СтрокаТаблицы);
	
	СтрокаТаблицы.Номенклатура 					= ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
	СтрокаТаблицы.ХарактеристикаНоменклатуры 	= ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
	СтрокаТаблицы.Цена 							= 0;
	СтрокаТаблицы.Сумма 						= 0;
	СтрокаТаблицы.Количество					= 0;
	СтрокаТаблицы.КоличествоВКомплекте			= 0;
	СтрокаТаблицы.ВыдачаСверхНорм				= Ложь;
	
	Если ЗначениеЗаполнено(СтрокаТаблицы.Комплект) Тогда
		ФормаДокумента.СкорректироватьКомплекты(СтруктураТекущихДанных);
	КонецЕсли;
		
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");	
	
КонецПроцедуры

//АсТБ_Alexey_102437_********************************************************************

Процедура ВыдачаСИЗ_ТоварыНеВыданоПоПричинеПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	ТекущиеДанные = ФормаДокумента.Элементы.Товары.ТекущиеДанные;
	
	СтруктураТекущихДанных = ПроцедурыРаботыСНормамиКлиент.ПеренестиТекущиеДанныеВыдачиВСтруктуру(ТекущиеДанные);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Комплект) Тогда
		ФормаДокумента.СкорректироватьКомплекты(СтруктураТекущихДанных);
	КонецЕсли;
		
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");

КонецПроцедуры

Процедура ВыдачаСИЗ_ТоварыНоменклатураНормыПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	//для данного алгоритма обработчик не вызывается, т.к. нет групп "ИЛИ"
	
КонецПроцедуры

Процедура ВыдачаСИЗ_ТоварыНоменклатураПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	ТекущиеДанные = ФормаДокумента.Элементы.Товары.ТекущиеДанные;
	
	//для произвольной и упрощенной выдачи размер по антропометрии не подбирается
	Если НЕ (ТекущийОбъект.ВидВыдачиСИЗ = ПредопределенноеЗначение("Перечисление.ВидыВыдачиСИЗ.ПроизвольнаяВыдача") ИЛИ ТекущийОбъект.ВидВыдачиСИЗ = ПредопределенноеЗначение("Перечисление.ВидыВыдачиСИЗ.УпрощеннаяВыдача")) Тогда
		ТекущиеДанные.ХарактеристикаНоменклатуры = ПроцедурыРаботыСНормамиСервер.ПолучитьХарактеристикуПоАнтропометрии(ТекущиеДанные.Номенклатура,ТекущиеДанные.Сотрудник);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		ТекущиеДанные.Цена 	= ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(ТекущиеДанные.Номенклатура,ТекущийОбъект.Организация,ТекущийОбъект.Дата);
		ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	Иначе
		ТекущиеДанные.Цена 	= 0;
		ТекущиеДанные.Сумма = 0;
	КонецЕсли;
	
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");
	
КонецПроцедуры

Процедура ВыдачаСИЗ_ТоварыХарактеристикаНоменклатурыПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	//для данного алгоритма обработчик не вызывается, т.к. нет свертки по номенклатуре нормы	
	
КонецПроцедуры

Процедура ВыдачаСИЗ_ТоварыКоличествоПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	ТекущиеДанные = ФормаДокумента.Элементы.Товары.ТекущиеДанные;
	
	//пока выключено: избыток "удобств"
	//Если НЕ ТекущийОбъект.ВидВыдачиСИЗ = ПредопределенноеЗначение("Перечисление.ВидыВыдачиСИЗ.ПроизвольнаяВыдача") Тогда
	//	Если Элемент.ТекущиеДанные.Количество = 0 Тогда
	//		Элемент.ТекущиеДанные.Количество = Элемент.ТекущиеДанные.КоличествоПотребность;
	//	Иначе
	//		Если Элемент.ТекущиеДанные.Количество > Элемент.ТекущиеДанные.КоличествоПотребность Тогда
	//			Элемент.ТекущиеДанные.Количество = Элемент.ТекущиеДанные.КоличествоПотребность;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Комплект) Тогда
		ПроцедурыРаботыСНормамиКлиент.СкорректироватьКоличествоКомплектующих(ТекущиеДанные.НормаВыдачи,ТекущиеДанные.Комплект,ТекущиеДанные.Количество,ТекущийОбъект);
		ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена * ТекущиеДанные.КоличествоВКомплекте;
	Иначе
		Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
			ТекущиеДанные.Цена 	= ЦенообразованиеСерверПереопределяемый.ПолучитьЦену(ТекущиеДанные.Номенклатура,ТекущийОбъект.Организация,ТекущийОбъект.Дата);
			ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
		Иначе
			ТекущиеДанные.Цена 	= 0;
			ТекущиеДанные.Сумма = 0;
		КонецЕсли;
		//ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	КонецЕсли;
	
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");	
	
КонецПроцедуры

Процедура ВыдачаСИЗ_ТоварыПроцентИзносаПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	ТекущиеДанные = ФормаДокумента.Элементы.Товары.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ПроцентИзноса) Тогда
		ТекущиеДанные.Сумма = 0;
	Иначе
		ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	КонецЕсли;
	
	ТекущийОбъект.СуммаДокумента = ТекущийОбъект.Товары.Итог("Сумма");	
	
КонецПроцедуры

Процедура ВыдачаСИЗ_ТоварыПередНачаломИзменения(Элемент,ТекущийОбъект,ФормаДокумента,Отказ) Экспорт
	
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыНеВыдано" ИЛИ  Элемент.ТекущийЭлемент.Имя = "ТоварыНеВыданоПоПричине" Тогда 
		//если есть строки, добавленные копированием, запрещаем редактирование невыдачи
		Если ФормаДокумента.ЕстьСкопированныеСтроки(Элемент.ТекущиеДанные.НормаВыдачи) Тогда
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатураНормы" Тогда //для данного алгоритма номенклатура нормы не редактируется
		Отказ = Истина;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатура" Тогда
		//для разобранных комплектов номенклатура не редактируется
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Комплект) Тогда 
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсДокументаЗаявкаНаВыдачу

Процедура ЗаявкаНаВыдачу_ТоварыНоменклатураНормыПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	//для данного алгоритма обработчик не вызывается, т.к. нет групп "ИЛИ"
	
КонецПроцедуры

Процедура ЗаявкаНаВыдачу_ТоварыНоменклатураПриИзменении(Элемент,ТекущийОбъект,ФормаДокумента) Экспорт
	
	ТекущиеДанные = ФормаДокумента.Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.ХарактеристикаНоменклатуры = ПроцедурыРаботыСНормамиСервер.ПолучитьХарактеристикуПоАнтропометрии(ТекущиеДанные.Номенклатура,ТекущиеДанные.Сотрудник);
	
КонецПроцедуры

Процедура ЗаявкаНаВыдачу_ТоварыПередНачаломИзменения(Элемент,ТекущийОбъект,ФормаДокумента,Отказ) Экспорт
	
	Если Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатураНормы" Тогда //для данного алгоритма номенклатура нормы не редактируется
		Отказ = Истина;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ТоварыНоменклатура" Тогда
		//для разобранных комплектов номенклатура не редактируется
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Комплект) Тогда 
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсДокументаСписанияВыданныхСИЗ

Процедура СписаниеСИЗ_УправлениеДоступностью(ФормаДокумента) Экспорт
	
	//ФормаДокумента.Элементы.ТоварыКоличество.Доступность = Ложь;
	//ФормаДокумента.Элементы.ТоварыКоличество.ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти