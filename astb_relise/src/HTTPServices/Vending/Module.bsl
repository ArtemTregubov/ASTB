
Функция ШаблонGetInfo(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	
	ИмяЗапроса = Запрос.ПараметрыURL["query"];
	
	Если НЕ СтрНайти(ИмяЗапроса,"getbalance") = 0 Тогда
	    Ответ.УстановитьТелоИзСтроки(Ответ_getbalance(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	    Возврат Ответ;
	КонецЕсли;	
		
	Если НЕ СтрНайти(ИмяЗапроса,"createtransaction") = 0 Тогда
	    Ответ.УстановитьТелоИзСтроки(Ответ_createtransaction(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	    Возврат Ответ;
	КонецЕсли;
	
	Если НЕ СтрНайти(ИмяЗапроса,"vend") = 0 Тогда
	    Ответ.УстановитьТелоИзСтроки(Ответ_vend(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	    Возврат Ответ;
	КонецЕсли;
	
	Если НЕ СтрНайти(ИмяЗапроса,"vendsuccess") = 0 Тогда
	    Ответ.УстановитьТелоИзСтроки(Ответ_vendsuccess(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	    Возврат Ответ;
	КонецЕсли;
	
	Если НЕ СтрНайти(ИмяЗапроса,"vendfailure") = 0 Тогда
	    Ответ.УстановитьТелоИзСтроки(Ответ_vendfailure(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	    Возврат Ответ;
	КонецЕсли;
	
	Если НЕ СтрНайти(ИмяЗапроса,"revalue") = 0 Тогда
	    Ответ.УстановитьТелоИзСтроки(Ответ_revalue(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	    Возврат Ответ;
	КонецЕсли;
	
	Ответ.УстановитьТелоИзСтроки(ВернутьСписокПользователей(),КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	Возврат Ответ;
	
КонецФункции

Функция ВернутьСписокПользователей()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Недействителен = ЛОЖЬ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОтветМассив = Новый Массив;
	Пока Выборка.Следующий() Цикл
		ОтветМассив.Добавить(Новый Структура("name,id",Выборка.Ссылка.Наименование,""+Выборка.Ссылка.УникальныйИдентификатор()));
	КонецЦикла;
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	Возврат Ответ.Закрыть();
	
КонецФункции

Функция Ответ_getbalance()
	
	ОтветМассив = Новый Массив;
	ОтветМассив.Добавить(Новый Структура("errorcode,balance,maxrevalue,pricelist,nerobuttons,dispense",0,100,200,1,2,3));
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	
	Возврат Ответ.Закрыть();
	
КонецФункции	

Функция Ответ_createtransaction()
	
	ОтветМассив = Новый Массив;
	ОтветМассив.Добавить(Новый Структура("errorcode,transactionid",0,100));
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	
	Возврат Ответ.Закрыть();	
	
КонецФункции

Функция Ответ_vend()
	
	ОтветМассив = Новый Массив;
	ОтветМассив.Добавить(Новый Структура("errorcode",0));
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	
	Возврат Ответ.Закрыть();	
	
КонецФункции

Функция Ответ_vendsuccess()
	
	ОтветМассив = Новый Массив;
	ОтветМассив.Добавить(Новый Структура("errorcode",0));
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	
	Возврат Ответ.Закрыть();	
	
КонецФункции

Функция Ответ_vendfailure()
	
	ОтветМассив = Новый Массив;
	ОтветМассив.Добавить(Новый Структура("errorcode",0));
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	
	Возврат Ответ.Закрыть();	
	
КонецФункции

Функция Ответ_revalue()
	
	ОтветМассив = Новый Массив;
	ОтветМассив.Добавить(Новый Структура("errorcode",0));
	
	Ответ = Новый ЗаписьJSON;
	Ответ.УстановитьСтроку();
	ЗаписатьJSON(Ответ,ОтветМассив); // сериализует ОтветМассив в формат JSON
	
	Возврат Ответ.Закрыть();	
	
КонецФункции












