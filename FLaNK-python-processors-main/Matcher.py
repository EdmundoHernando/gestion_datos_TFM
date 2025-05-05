from nifiapi.flowfiletransform import FlowFileTransform, FlowFileTransformResult
from nifiapi.properties import PropertyDescriptor, StandardValidators, ExpressionLanguageScope

class MatchSchema(FlowFileTransform):
    class Java:
        implements = ['org.apache.nifi.python.processor.FlowFileTransform']

    class ProcessorDetails:
        version = '2.0.0'
        description = "Determines the schemas that match or determines if none of the schemas match."
        tags = ["schema", "match", "flowfile", "content", "text"]

    MATCH_SCHEMA = PropertyDescriptor(
        name="Output first match",
        description="Output the first match (true) or wait to process all schemas and see if any more match (false).",
        required=True,
        validators=[StandardValidators.BOOLEAN_VALIDATOR],
        expression_language_scope=ExpressionLanguageScope.NONE
    )

    property_descriptors = [MATCH_SCHEMA]

    def __init__(self, **kwargs):
        super().__init__()
        self.false_count = 0
        self.true_count = 0
        self.file_count = 0
        self.schema = None
    
    def getPropertyDescriptors(self):
        return self.property_descriptors
    
    def transform(self, context, flowfile):
        # Obtener atributos del FlowFile
        fragment_index = flowfile.getAttribute("fragment.index")
        fragment_count = flowfile.getAttribute("fragment.count")
        found = flowfile.getAttribute("found")

        # Validación de atributos
        if fragment_index is None or fragment_count is None or found is None:
            return FlowFileTransformResult(relationship="failure")

        # Validar fragment_count como número
        try:
            fragment_count = int(fragment_count)
        except ValueError:
            return FlowFileTransformResult(relationship="failure")

        # Validar el valor de found
        found = found.strip().upper()
        if found not in ("TRUE", "FALSE"):
            return FlowFileTransformResult(relationship="failure")

        # Procesar fragmentos
        if self.file_count < fragment_count:
            self.file_count += 1
            if found == "TRUE":
                self.schema = flowfile.getAttribute("schema_harmonized")
                self.true_count += 1
            else:
                self.false_count += 1

        # Verificar cuando todos los fragmentos han sido procesados
        if self.file_count == fragment_count:
            if self.false_count == self.file_count:
                self._reset_counters()
                return FlowFileTransformResult(relationship="success", attributes={"harmonize": "true"})
            if self.true_count == 1:
                self._reset_counters()
                return FlowFileTransformResult(relationship="success", attributes={"harmonize": "false", "schema_harmonized": self.schema})
            else:
                self._reset_counters()
                return FlowFileTransformResult(relationship="success", attributes={"harmonize": "multiple"})

        # **Retorno de seguridad** en caso de que ninguna condición anterior se cumpla
        return FlowFileTransformResult(relationship="failure")

    def _reset_counters(self):
        """Método auxiliar para reiniciar contadores después de procesar todos los fragmentos."""
        self.false_count = 0
        self.true_count = 0
        self.file_count = 0
        self.schema = None
