&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВыполнитьЗагрузкуНаСервере();
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СоответствияХарактеристикНоменклатуры"));
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНаСервере()
	
	ПроцедурыРаботыСНормамиСервер.ВыполнитьЗагрузкуСоответствийХарактеристик();
		
КонецПроцедуры